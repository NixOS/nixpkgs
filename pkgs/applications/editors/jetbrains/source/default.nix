let
<<<<<<< HEAD
  ides = builtins.fromJSON (builtins.readFile ./sources.json);
=======
  ides = builtins.fromJSON (builtins.readFile ./ides.json);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
{
  callPackage,
}:
builtins.mapAttrs (
  _: info: callPackage ./build.nix (info // { mvnDeps = ./. + "/${info.mvnDeps}"; })
) ides
