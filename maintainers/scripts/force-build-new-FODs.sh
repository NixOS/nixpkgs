#!/usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnugrep gnused nix curl jq
#
# Given directories <before-nixpkgs> and <after-nixpkgs>, will find
# new Fixed-Output-Derivations ("FODs") introduced by <after-nixpkgs>,
# and attempt to build/download them locally, disregarding any caches
# that claim to have a substitutable binary with the given hash, and
# compares the actual hash with the purported output hash.
#
# On completion, outputs to stdout a series of json objects, each
# representing a FOD that has been checked, containing at least
# an `origDrv` and `status` key.
#
# Exit code is nonzero if at least one FOD failed the check.
#
# Also recognizes $REALIZE_PROCESSES and $REALIZE_TIMEOUT environment
# vars
#

set -e -o pipefail

if [ $# != '2' ] ; then
  echo "usage: $0 <before-nixpkgs> <after-nixpkgs>" >&2
  exit 2
fi

export WORKDIR=$(mktemp -d)
echo "Putting intermediate files in $WORKDIR" >&2
NIXPKGS_BEFORE="$(realpath $1)"
NIXPKGS_AFTER="$(realpath $2)"

OUTPATHS_NIX=$(mktemp)
cat > "$OUTPATHS_NIX" <<"EOF"
# originally https://github.com/NixOS/ofborg/blob/74f38efa7ef6f0e8e71ec3bfc675ae4fb57d7491/ofborg/src/outpaths.nix
{ checkMeta
, path ? ./.
, supportedSystems ? [ builtins.currentSystem ]
}:
let
  lib = import (path + "/lib");
  hydraJobs = import (path + "/pkgs/top-level/release.nix")
    # Compromise: accuracy vs. resources needed for evaluation.
    {
      inherit supportedSystems;

      nixpkgsArgs = {
        config = {
          allowAliases = false;
          allowBroken = true;
          allowUnfree = true;
          allowInsecurePredicate = x: true;
          checkMeta = checkMeta;

          handleEvalIssue = reason: errormsg:
            let
              fatalErrors = [
                "unknown-meta"
                "broken-outputs"
              ];
            in
            if builtins.elem reason fatalErrors
            then abort errormsg
            else true;

          inHydra = true;
        };
      };
    };
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  # hydraJobs leaves recurseForDerivations as empty attrmaps;
  # that would break nix-env and we also need to recurse everywhere.
  tweak = lib.mapAttrs
    (name: val:
      if name == "recurseForDerivations" then true
      else if lib.isAttrs val && val.type or null != "derivation"
      then recurseIntoAttrs (tweak val)
      else val
    );

  # Some of these contain explicit references to platform(s) we want to avoid;
  # some even (transitively) depend on ~/.nixpkgs/config.nix (!)
  blacklist = [
    "tarball"
    "metrics"
    "manual"
    "darwin-tested"
    "unstable"
    "stdenvBootstrapTools"
    "moduleSystem"
    "lib-tests" # these just confuse the output
  ];

in
tweak (builtins.removeAttrs hydraJobs blacklist)
EOF

export NIX_CURRENTSYSTEM="$(nix eval --impure --raw --expr 'builtins.currentSystem')"


echo "Evaluating attr-addressable derivations in after-nixpkgs..." >&2
# generate json of attr-addressable derivations in "after" nixpkgs mapped to their attrPath
nix-env -f "$OUTPATHS_NIX" -qa --attr-path --drv-path --no-name \
  --argstr path "$NIXPKGS_AFTER" \
  --arg checkMeta false \
  | jq -Rn '[inputs | split("\\s+"; null) | {key: .[1], value: .[0] | rtrimstr("." + env.NIX_CURRENTSYSTEM)}] | from_entries' \
  > "$WORKDIR/attrdrvs.after.json"
echo "Evaluating attr-addressable derivations in before-nixpkgs..." >&2
# generate json of attr-addressable derivations in "before" nixpkgs mapped to `null`
nix-env -f "$OUTPATHS_NIX" -qa --attr-path --drv-path --no-name \
  --argstr path "$NIXPKGS_BEFORE" \
  --arg checkMeta false \
  | jq -Rn '[inputs | split("\\s+"; null) | {key: .[1], value: null}] | from_entries' \
  > "$WORKDIR/attrdrvs.before.json"


# generate json array of attrPaths changed (or new) in "after" nixpkgs
jq -n '[ $after[0] + $before[0] | to_entries | .[] | .value | strings ]' \
  --slurpfile before "$WORKDIR/attrdrvs.before.json" \
  --slurpfile after "$WORKDIR/attrdrvs.after.json" \
  > "$WORKDIR/changedattrdrvs.attrs.json"

echo "Found $(jq -r 'length' < "$WORKDIR/changedattrdrvs.attrs.json") attrPaths with new .drvs" >&2

CHANGEDATTRDRVS_NIX=$(mktemp)
cat > "$CHANGEDATTRDRVS_NIX" <<"EOF"
# given a json array of (dot-separated) package attr paths in
# newdrvsJsonFile, produce an array of those derivations

{ pkgsPath, newdrvsJsonFile, outpathsNix }: let
  pkgs = import outpathsNix { checkMeta = false; path = pkgsPath;};
  lib = (import pkgsPath {}).lib;
in
  builtins.filter (d: d != null) (
    builtins.map
    (p: lib.attrByPath (lib.splitString "." p) null pkgs)
    (builtins.fromJSON (builtins.readFile newdrvsJsonFile))
  )
EOF


echo "Instantiating .drvs for affected attrs in after-nixpkgs..." >&2
# instantiate all .drv files needed for the affected attrs in the "after" nixpkgs,
# noting the attr-addressable .drv paths
nix-instantiate "$CHANGEDATTRDRVS_NIX" \
  --arg pkgsPath "$NIXPKGS_AFTER" \
  --arg newdrvsJsonFile "$WORKDIR/changedattrdrvs.attrs.json" \
  --arg outpathsNix "$OUTPATHS_NIX" \
  | cut -d '!' -f 1 \
  > "$WORKDIR/changedattrdrvs.after.drvs"


echo "Instantiating .drvs for affected attrs in before-nixpkgs..." >&2
# instantiate all .drv files needed for the affected attrs in the "before" nixpkgs,
# noting the attr-addressable .drv paths. this won't be perfectly accurate as some
# of the attrPaths may be new in the "after" nixpkgs. CHANGEDATTRDRVS_NIX makes
# special provisions to ignore these. this may also miss some .drv files that are
# present in the "before" nixpkgs, but under a different attrPath.
nix-instantiate "$CHANGEDATTRDRVS_NIX" \
  --arg pkgsPath "$NIXPKGS_BEFORE" \
  --arg newdrvsJsonFile "$WORKDIR/changedattrdrvs.attrs.json" \
  --arg outpathsNix "$OUTPATHS_NIX" \
  | cut -d '!' -f 1 \
  > "$WORKDIR/changedattrdrvs.before.drvs"


echo "Gathering requisite .drvs in after-nixpkgs..." >&2
# list *all* requisite .drvs for the sets of attr-addressable .drvs in the "after"
# and "before" nixpkgs respectively
nix-store -qR $(< "$WORKDIR/changedattrdrvs.after.drvs") 2> /dev/null \
  | grep '.drv$' | sort > "$WORKDIR/allchangeddrvs.after.drvs"
echo "Gathering requisite .drvs in before-nixpkgs..." >&2
nix-store -qR $(< "$WORKDIR/changedattrdrvs.before.drvs") 2> /dev/null \
  | grep '.drv$' | sort > "$WORKDIR/allchangeddrvs.before.drvs"


# reduce this list to just those .drvs that are new in the "after" nixpkgs
comm -13 "$WORKDIR/allchangeddrvs.before.drvs" "$WORKDIR/allchangeddrvs.after.drvs" \
  > "$WORKDIR/allnewdrvs.drvs"


echo "Found $(wc -l "$WORKDIR/allnewdrvs.drvs" | cut -d ' ' -f 1) after-nixpkgs .drvs not present in before-nixpkgs"

# reduce this further to just those that are FODs
nix derivation show $(< "$WORKDIR/allnewdrvs.drvs") 2> /dev/null \
  | jq -r 'to_entries | .[] | select(.value.outputs.out.hash) | .key' \
  > "$WORKDIR/newfods.drvs"


echo "Generating tainted clones of $(wc -l "$WORKDIR/newfods.drvs" | cut -d ' ' -f 1) new FOD .drvs..." >&2
# for each of these "new" FODs, generate a "tainted" clone with an incorrect outhash
echo -n > "$WORKDIR/taintedfods.jsonl"
while read ORIGDRV ; do
  export ORIGDRV
  HASHALGO=$(
    nix derivation show "$ORIGDRV" 2> /dev/null \
      | jq -r '.[env.ORIGDRV].outputs.out.hashAlgo'
  )
  export ORIGHASH_SRI="$(
    nix-hash \
      --type ${HASHALGO#r:} \
      --to-sri $(
        nix derivation show "$ORIGDRV" 2> /dev/null \
          | jq -r '.[env.ORIGDRV].outputs.out.hash'
      )
  )"
  DRVNAME=$(nix derivation show "$ORIGDRV" 2> /dev/null | jq -r '.[env.ORIGDRV].name')
  case "$HASHALGO" in
    *md5)
      HASHBYTES=16
      ;;
    *sha1)
      HASHBYTES=20
      ;;
    *sha256)
      HASHBYTES=32
      ;;
    *sha512)
      HASHBYTES=64
      ;;
  esac
  export NEWHASH="$(od -N $HASHBYTES -A n -t x1 -w$HASHBYTES < /dev/urandom | tr -d -c '[:xdigit:]')"
  if [[ "$HASHALGO" = r:* ]] ; then
    OUTPATHHASH=$(nix-hash --type sha256 --truncate --base32 --flat \
      <(echo -n "source:${HASHALGO#r:}:$NEWHASH:/nix/store:$DRVNAME") \
    )
  else
    OUTPATHHASH=$(nix-hash --type sha256 --truncate --base32 --flat \
      <(echo -n "output:out:sha256:$(echo -n "fixed:out:sha256:$NEWHASH:" | sha256sum | tr -d -c '[:xdigit:]'):/nix/store:$DRVNAME") \
    )
  fi
  export OUTPATH="/nix/store/$OUTPATHHASH-$DRVNAME"
  nix derivation show "$ORIGDRV" 2> /dev/null \
    | jq '.[env.ORIGDRV] | .outputs.out.hash = env.NEWHASH | .outputs.out.path = env.OUTPATH | .env.out = env.OUTPATH' \
    | nix derivation add 2> /dev/null \
    | jq -Rc '{origDrv: env.ORIGDRV, taintedDrv: ., origHashSRI: env.ORIGHASH_SRI}' \
    >> "$WORKDIR/taintedfods.jsonl"
done < "$WORKDIR/newfods.drvs"


echo "Realizing tainted .drvs..." >&2
# attempt to realize these tainted .drvs and note whether they produce the
# originally purported hash in their "got:" line when they fail (they
# should definitely fail). if we need to retrieve build logs this can be
# done from `nix log`
REALIZE_TAINTED_SH=$(mktemp)
cat > "$REALIZE_TAINTED_SH" <<"EOF"
# called by each iteration of xargs, expecting a line from taintedfods.jsonl
# to be supplied as $1. also expects $WORKDIR and $XARGS_PROCESS_SLOT to be
# set.

ORIG_HASH_SRI=$(jq -r '.origHashSRI' <<<"$1")
TAINTED_DRV=$(jq -r '.taintedDrv' <<<"$1")

GOT_STRING=$(
  set +e
  nix-store --realize --timeout "${REALIZE_TIMEOUT:-900}" -Q "$TAINTED_DRV" 2>&1 | grep -E "got:\s+[[:alnum:]+=-]+\b";
  exit ${PIPESTATUS[0]}
)
export NIX_EXIT_CODE=$?
export GOT_STRING  # defining and exporting in one command affects exit code

if grep -F "$ORIG_HASH_SRI" <<<"$GOT_STRING" > /dev/null ; then
  echo "  passed for $TAINTED_DRV" >&2
  # annotate json with status
  jq -c '.nixExitCode = env.NIX_EXIT_CODE | .status = "passed"' <<<"$1" >> "$WORKDIR/fragments/$XARGS_PROCESS_SLOT.jsonl"
else
  echo "  failed for $TAINTED_DRV with exit code $NIX_EXIT_CODE: $GOT_STRING" >&2
  # annotate json with status and the string we *actually* got (if anything)
  jq -c '.nixExitCode = env.NIX_EXIT_CODE | .status = "failed" | .taintedGotString = env.GOT_STRING' <<<"$1" >> "$WORKDIR/fragments/$XARGS_PROCESS_SLOT.jsonl"
fi
EOF
mkdir -p "$WORKDIR/fragments"
xargs -P "${REALIZE_PROCESSES:-8}" --process-slot-var=XARGS_PROCESS_SLOT -I '{}' -d '\n' \
  -- bash "$REALIZE_TAINTED_SH" '{}' \
  < "$WORKDIR/taintedfods.jsonl"


if compgen -G "$WORKDIR/fragments/*.jsonl" > /dev/null ; then
  # output combined results files
  cat "$WORKDIR"/fragments/*.jsonl

  # allow exit status to exit script
  cat "$WORKDIR"/fragments/*.jsonl | jq -se 'all(.status == "passed")' > /dev/null
fi
