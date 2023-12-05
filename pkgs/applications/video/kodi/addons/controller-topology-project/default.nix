{ lib, stdenv, fetchFromGitHub, toKodiAddon, addonDir }:
let
  drv = stdenv.mkDerivation {
    pname = "controller-topology-project";
    version = "unstable-2022-11-19";

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = "controller-topology-project";
      rev = "d96894ca68678000f26f56d14aa3ceea47b1a3a8";
      sha256 = "sha256-KfDr2bSJFey/aNO5WzoOQ8Mz0v4uitKkOesymIMZH1o=";
    };

    postPatch = ''
      # remove addons already included in the base kodi package
      rm -r addons/game.controller.default
      rm -r addons/game.controller.snes
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out${addonDir}
      cp -r addons/* $out${addonDir}
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/kodi-game/controller-topology-project";
      description = "Models how controllers connect to and map to each other for all gaming history";
      license = with licenses; [ odbl ];
      maintainers = teams.kodi.members;
    };
  };
in
  toKodiAddon drv
