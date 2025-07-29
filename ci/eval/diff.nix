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
  /*
    Computes the key difference between two attrs

    {
      added: [ <keys only in the second object> ],
      removed: [ <keys only in the first object> ],
      changed: [ <keys with different values between the two objects> ],
    }
  */
  diff =
    let
      filterKeys = cond: attrs: lib.attrNames (lib.filterAttrs cond attrs);
    in
    old: new: {
      added = filterKeys (n: _: !(old ? ${n})) new;
      removed = filterKeys (n: _: !(new ? ${n})) old;
      changed = filterKeys (
        n: v:
        # Filter out attributes that don't exist anymore
        (new ? ${n})

        # Filter out attributes that are the same as the new value
        && (v != (new.${n}))
      ) old;
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

  beforeAttrs = getAttrs beforeDir;
  afterAttrs = getAttrs afterDir;
  diffAttrs = diff beforeAttrs afterAttrs;
  diffJson = writeText "diff.json" (builtins.toJSON diffAttrs);
in
runCommand "diff" { } ''
  mkdir -p $out/${evalSystem}

  cp -r ${beforeDir} $out/before
  cp -r ${afterDir} $out/after
  cp ${diffJson} $out/${evalSystem}/diff.json
''
