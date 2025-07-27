{
  stdenv,
  pkgs,
  lib,
  nodejs-18_x,
  runtimeShell,
}:

let
  nodejs = nodejs-18_x;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  pigallery2 = lib.head (lib.attrValues nodePackages);

  combined = pigallery2.override {
    meta = {
      description = "Fast directory-first photo gallery website";
      license = lib.licenses.mit;
      homepage = "https://bpatrik.github.io/pigallery2/";
      maintainers = with lib.maintainers; [ GaetanLepage ];
      platforms = lib.platforms.unix;
    };
  };
in
combined
