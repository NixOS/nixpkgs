{ lib, substitute }:

/*
  This is a wrapper around `substitute` in the stdenv, designed to be as easy to use as
  `substituteAll` but have fewer pitfalls.

  Attribute arguments:

  - `srcOrAttrs`: either the path to the file to substitute, or an attrset that fits into `substitute`

  - `attrs`: each entry in this set corresponds to a `--subst-var-by` entry in `substitute`.
    See https://nixos.org/manual/nixpkgs/stable/#fun-substitute

  Example:

  ```nix
  { substituteAttrs }:

  substituteAttrs ./greeting.txt { world = "hello"; }
  ```

  See ../../test/substitute for tests
*/
srcOrAttrs: attrs:

let
  subst-var-by = name: value: [
    "--subst-var-by"
    name
    value
  ];

  substituteArgs = (if lib.isAttrs srcOrAttrs then srcOrAttrs else { src = srcOrAttrs; }) // {
    substitutions =
      (srcOrAttrs.substitutions or [ ])
      ++ lib.concatLists (lib.mapAttrsToList subst-var-by attrs);
  };
in

substitute substituteArgs
