{
  haskellPackages,
  haskell,
}:

let
  inherit (haskell.lib.compose)
    justStaticExecutables
    ;
in
justStaticExecutables haskellPackages.fourmolu
