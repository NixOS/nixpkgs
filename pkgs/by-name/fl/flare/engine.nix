{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

let
  common = import ./common.nix { inherit lib nix-update-script; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flare-engine";
  inherit (common) version;

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QwrSMkJE8dNIODlmdi1c6qgTULhJP9HEV8wI7k5vHAA=";
  };

  patches = [ ./desktop.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  meta = {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.unix;
    inherit (common) maintainers;
  };
})
