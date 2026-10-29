{
  haskell,
  haskellPackages,
  lib,
}:

haskell.lib.compose.justStaticExecutables (
  haskell.lib.compose.overrideCabal (oldAttrs: {
    maintainers = (oldAttrs.maintainers or [ ]) ++ [
      lib.maintainers.cdepillabout
    ];

    configureFlags = (oldAttrs.configureFlags or [ ]) ++ [ "-fbuildexe" ];

    buildDepends = (oldAttrs.buildDepends or [ ]) ++ [ haskellPackages.optparse-applicative ];
  }) haskellPackages.pretty-simple
)
