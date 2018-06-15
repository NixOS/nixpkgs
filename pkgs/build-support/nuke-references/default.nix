# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existant
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{ stdenv, perl }:

stdenv.mkDerivation {
  name = "nuke-references";
  builder = ./builder.sh;
  inherit perl;
}
