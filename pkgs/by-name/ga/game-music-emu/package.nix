{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "0.6.3";
  pname = "game-music-emu";

  src = fetchFromGitHub {
    owner = "libgme";
    repo = "game-music-emu";
    tag = version;
    hash = "sha256-XmPcFfKsEe07hH7f0xMs9hRJshOO/p58Zm9fYsmCCoA=";
  };

  cmakeFlags = [ "-DENABLE_UBSAN=OFF" ];
  nativeBuildInputs = [
    cmake
    removeReferencesTo
  ];
  buildInputs = [ zlib ];

  # It used to reference it, in the past, but thanks to the postFixup hook, now
  # it doesn't.
  disallowedReferences = [ stdenv.cc.cc ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    remove-references-to -t ${stdenv.cc.cc} "$(readlink -f $out/lib/libgme.so)"
  '';

  meta = with lib; {
    homepage = "https://github.com/libgme/game-music-emu/wiki";
    description = "Collection of video game music file emulators";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
