{
  haskell,
  haskellPackages,
  lib,
  stdenv,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides = {
    description = "OAuth credential MAnager";
    homepage = "https://github.com/pdobsan/oama";
    maintainers = with lib.maintainers; [ aidalgol ];

    passthru.updateScript = ./update.sh;
  };

  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  # FIXME: eliminate all erroneous references on aarch64-darwin manually,
  # see https://github.com/NixOS/nixpkgs/issues/318013
  (
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      lib.id
    else
      justStaticExecutables
  )
]
