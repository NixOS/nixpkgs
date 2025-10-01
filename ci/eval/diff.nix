{
  lib,
  runCommand,
  writeText,
}:

{
  beforeDir,
  afterDir,
  evalSystem,
}:

let
  # Usually we expect a derivation, but when evaluating in multiple separate steps, we pass
  # nix store paths around. These need to be turned into (fake) derivations again to track
  # dependencies properly.
  # We use two steps for evaluation, because we compare results from two different checkouts.
  # CI additionalls spreads evaluation across multiple workers.
  before = if lib.isDerivation beforeDir then beforeDir else lib.toDerivation beforeDir;
  after = if lib.isDerivation afterDir then afterDir else lib.toDerivation afterDir;

  /*
    Computes the key difference between two attrs

    {
      added: [ <keys only in the second object> ],
      removed: [ <keys only in the first object> ],
      changed: [ <keys with different values between the two objects> ],
      rebuilds: [ <keys in the second object with values not present at all in first object> ],
    }
  */
  diff =
    old: new:
    let
      filterKeys = cond: attrs: lib.attrNames (lib.filterAttrs cond attrs);
      oldOutputs = lib.pipe old [
        (lib.mapAttrsToList (_: lib.attrValues))
        lib.concatLists
        (lib.flip lib.genAttrs (_: true))
      ];
    in
    {
      added = filterKeys (n: _: !(old ? ${n})) new;
      removed = filterKeys (n: _: !(new ? ${n})) old;
      changed = filterKeys (
        n: v:
        # Filter out attributes that don't exist anymore
        (new ? ${n})

        # Filter out attributes that are the same as the new value
        && (v != (new.${n}))
      ) old;
      # A "rebuild" is every attrpath ...
      rebuilds = filterKeys (
        _: pkg:
        # ... that has at least one output ...
        lib.any (
          output:
          # ... which has not been built in "old" already.
          !(oldOutputs ? ${output})
        ) (lib.attrValues pkg)
      ) new;
    };

  getAttrs =
    dir:
    let
      raw = builtins.readFile "${dir}/${evalSystem}/paths.json";
      # The file contains Nix paths; we need to ignore them for evaluation purposes,
      # else there will be a "is not allowed to refer to a store path" error.
      data = builtins.unsafeDiscardStringContext raw;
    in
    builtins.fromJSON data;

  beforeAttrs = getAttrs before;
  afterAttrs = getAttrs after;
  diffAttrs = diff beforeAttrs afterAttrs;
  diffJson = writeText "diff.json" (builtins.toJSON diffAttrs);
in
runCommand "diff" { } ''
  mkdir -p $out/${evalSystem}

  cp -r ${before} $out/before
  cp -r ${after} $out/after
  cp ${diffJson} $out/${evalSystem}/diff.json
''
