{ lib, stdenvNoCC }:
# see the substituteAll in the nixpkgs documentation for usage and constraints
args:
let
  # keep this in sync with substituteAll
  isInvalidArgName = x: builtins.match "^[a-z][a-zA-Z0-9_]*$" x == null;
  invalidArgs = builtins.filter isInvalidArgName (builtins.attrNames args);
in
if invalidArgs == [ ] then
  stdenvNoCC.mkDerivation (
    {
      name = if args ? name then args.name else baseNameOf (toString args.src);
      builder = ./substitute-all.sh;
      inherit (args) src;
      preferLocalBuild = true;
      allowSubstitutes = false;
    }
    // args
  )
else
  throw ''
    Argument names for `pkgs.substituteAll` must:
      - start with a lower case ASCII letter
      - only contain ASCII letters, digits and underscores
    Found invalid argument names: ${lib.concatStringsSep ", " invalidArgs}.
  ''
