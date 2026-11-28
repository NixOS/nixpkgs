{ lib, stdenvNoCC }:
/*
  This is a wrapper around `substitute` in the stdenv.

  Attribute arguments:
  - `name` (optional): The name of the resulting derivation
  - `src`: The path to the file to substitute
  - `substitutions`: The list of substitution arguments to pass
    See https://nixos.org/manual/nixpkgs/stable/#fun-substitute

  Example:

  ```nix
  { substitute }:
  substitute {
    src = ./greeting.txt;
    substitutions = [
      "--replace"
      "world"
      "paul"
    ];
  }
  ```

  See ../../test/substitute for tests
*/
args:

let
  name = args.name or (baseNameOf args.src);
in
stdenvNoCC.mkDerivation (
  {
    inherit name;
    builder = ./substitute.sh;
    inherit (args) src;
    preferLocalBuild = true;
    allowSubstitutes = false;
    strictDeps = true;
    __structuredAttrs = true;
  }
  // args
  // lib.optionalAttrs (args ? substitutions) {
    substitutions =
      assert
        lib.isList args.substitutions
        || throw ''pkgs.substitute: For "${name}", `substitutions` is passed, which is expected to be a list, but it's a ${builtins.typeOf args.substitutions} instead.'';
      args.substitutions;
  }
)
