#!/usr/bin/env bash
set -e

# --print: avoid dependency on environment
optPrint=
if [ "$1" == "--print" ]; then
    optPrint=true
    shift
fi

if [ "$#" != 1 ] && [ "$#" != 2 ]; then
    cat <<EOF
    Usage: $0 [--print] from-commit-spec [to-commit-spec]
        You need to be in a git-controlled nixpkgs tree.
        The current state of the tree will be used if the second commit is missing.

        Examples:
          effect of latest commit:
              $ $0 HEAD^
              $ $0 --print HEAD^
          effect of the whole patch series for 'staging' branch:
              $ $0 origin/staging staging
EOF
    exit 1
fi

# A slightly hacky way to get the config.
parallel="$(echo 'config.rebuild-amount.parallel or false' | nix-repl . 2>/dev/null \
            | grep -v '^\(nix-repl.*\)\?$' | tail -n 1 || true)"

echo "Estimating rebuild amount by counting changed Hydra jobs (parallel=${parallel:-unset})."

toRemove=()

cleanup() {
    rm -rf "${toRemove[@]}"
}
trap cleanup EXIT

MKTEMP='mktemp --tmpdir nix-rebuild-amount-XXXXXXXX'

nixexpr() {
    cat <<EONIX
        let
          lib = import $1/lib;
          hydraJobs = import $1/pkgs/top-level/release.nix
            # Compromise: accuracy vs. resources needed for evaluation.
            { supportedSystems = cfg.systems or [ "x86_64-linux" "x86_64-darwin" ]; };
          cfg = (import $1 {}).config.rebuild-amount or {};

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
            "tarball" "metrics" "manual"
            "darwin-tested" "unstable" "stdenvBootstrapTools"
            "moduleSystem" "lib-tests" # these just confuse the output
          ];

        in
          tweak (builtins.removeAttrs hydraJobs blacklist)
EONIX
}

# Output packages in tree $2 that weren't in $1.
# Changing the output hash or name is taken as a change.
# Extra nix-env parameters can be in $3
newPkgs() {
    # We use files instead of pipes, as running multiple nix-env processes
    # could eat too much memory for a standard 4GiB machine.
    local -a list
    for i in 1 2; do
        local l="$($MKTEMP)"
        list[$i]="$l"
        toRemove+=("$l")

        local expr="$($MKTEMP)"
        toRemove+=("$expr")
        nixexpr "${!i}" > "$expr"

        nix-env -f "$expr" -qaP --no-name --out-path --show-trace $3 \
            | sort > "${list[$i]}" &

        if [ "$parallel" != "true" ]; then
            wait
        fi
    done

    wait
    comm -13 "${list[@]}"
}

# Prepare nixpkgs trees.
declare -a tree
for i in 1 2; do
    if [ -n "${!i}" ]; then # use the given commit
        dir="$($MKTEMP -d)"
        tree[$i]="$dir"
        toRemove+=("$dir")

        git clone --shared --no-checkout --quiet . "${tree[$i]}"
        (cd "${tree[$i]}" && git checkout --quiet "${!i}")
    else #use the current tree
        tree[$i]="$(pwd)"
    fi
done

newlist="$($MKTEMP)"
toRemove+=("$newlist")
# Notes:
#    - the evaluation is done on x86_64-linux, like on Hydra.
#    - using $newlist file so that newPkgs() isn't in a sub-shell (because of toRemove)
newPkgs "${tree[1]}" "${tree[2]}" '--argstr system "x86_64-linux"' > "$newlist"

# Hacky: keep only the last word of each attribute path and sort.
sed -n 's/\([^. ]*\.\)*\([^. ]*\) .*$/\2/p' < "$newlist" \
    | sort | uniq -c

if [ -n "$optPrint" ]; then
    echo
    cat "$newlist"
fi
