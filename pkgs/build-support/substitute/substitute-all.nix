{ stdenvNoCC }:

args:

# see the substituteAll in the nixpkgs documentation for usage and constraints
stdenvNoCC.mkDerivation ({
  name = if args ? name then args.name else baseNameOf (toString args.src);
  builder = ./substitute-all.sh;
  inherit (args) src;
  preferLocalBuild = true;
  allowSubstitutes = false;
} // args)
