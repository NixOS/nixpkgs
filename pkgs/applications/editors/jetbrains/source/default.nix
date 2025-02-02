let
  ides = builtins.fromJSON (builtins.readFile ./ides.json);
in
{
  callPackage,
}:
builtins.mapAttrs (
  _: info: callPackage ./build.nix (info // { mvnDeps = ./. + "/${info.mvnDeps}"; })
) ides
