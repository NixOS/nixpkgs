{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.6.4";
  pname = "game-music-emu";

  src = fetchFromGitHub {
    owner = "libgme";
    repo = "game-music-emu";
    tag = finalAttrs.version;
    hash = "sha256-qGNWFFUUjv2R5e/nQrriAyDJCARISqNB8e5/1zEJ3fk=";
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
