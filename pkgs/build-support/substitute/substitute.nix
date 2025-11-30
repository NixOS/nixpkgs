{ lib, stdenvNoCC }:
/*
  This is a wrapper around `substitute` in the stdenv.

  Attribute arguments:
  - `name` (optional): The name of the resulting derivation
  - `src`: The path to the file to substitute
  - `substitutions`: The list of substitution arguments to pass
    See https://nixos.org/manual/nixpkgs/stable/#fun-substitute
  - `replacements`: Deprecated version of `substitutions`
    that doesn't support spaces in arguments.

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
  name = if args ? name then args.name else baseNameOf (toString args.src);
  deprecationReplacement = lib.pipe args.replacements [
    lib.toList
    (map (lib.splitString " "))
    lib.concatLists
    (lib.concatMapStringsSep " " lib.strings.escapeNixString)
  ];
  optionalDeprecationWarning =
    # substitutions is only available starting 24.05.
    # TODO: Remove support for replacements sometime after the next release
    lib.warnIf (args ? replacements && lib.oldestSupportedReleaseIsAtLeast 2405) ''
      pkgs.substitute: For "${name}", `replacements` is used, which is deprecated since it doesn't support arguments with spaces. Use `substitutions` instead:
        substitutions = [ ${deprecationReplacement} ];'';
in
optionalDeprecationWarning stdenvNoCC.mkDerivation (
  {
    inherit name;
    builder = ./substitute.sh;
    inherit (args) src;
    preferLocalBuild = true;
  }
  // args
  // lib.optionalAttrs (args ? substitutions) {
    substitutions =
      assert lib.assertMsg (lib.isList args.substitutions)
        ''pkgs.substitute: For "${name}", `substitutions` is passed, which is expected to be a list, but it's a ${builtins.typeOf args.substitutions} instead.'';
      lib.escapeShellArgs args.substitutions;
  }
)
