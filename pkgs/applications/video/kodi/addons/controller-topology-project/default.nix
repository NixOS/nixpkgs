{ lib, stdenv, fetchFromGitHub, toKodiAddon, addonDir }:
let
  drv = stdenv.mkDerivation {
    pname = "controller-topology-project";
    version = "unstable-2022-01-22";

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = "controller-topology-project";
      rev = "e2a9bac903f21b2acfeee374070cfc97d03aba2d";
      sha256 = "sha256-o6uKxOjEYNAK27drvNOokOFPdjkOEnr49mBre9ycM0w=";
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
