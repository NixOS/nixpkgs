{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.6.3";
  pname = "game-music-emu";

  src = fetchFromGitHub {
    owner = "libgme";
    repo = "game-music-emu";
    tag = finalAttrs.version;
    hash = "sha256-XmPcFfKsEe07hH7f0xMs9hRJshOO/p58Zm9fYsmCCoA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/libgme/game-music-emu/wiki";
    description = "Collection of video game music file emulators";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
})
