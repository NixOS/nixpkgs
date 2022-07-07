{ stdenvNoCC }:

args:

# This is a wrapper around `substitute` in the stdenv.
# The `replacements` attribute should be a list of list of arguments
# to `substitute`, such as `[ "--replace" "sourcetext" "replacementtext" ]`
stdenvNoCC.mkDerivation ({
  name = if args ? name then args.name else baseNameOf (toString args.src);
  builder = ./substitute.sh;
  inherit (args) src;
  preferLocalBuild = true;
  allowSubstitutes = false;
} // args // { replacements = args.replacements; })
