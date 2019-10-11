# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existant
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{ stdenvNoCC, perl }:

stdenvNoCC.mkDerivation {
  name = "nuke-references";
  builder = ./builder.sh;
  # FIXME: get rid of perl dependency.
  inherit perl;
}
