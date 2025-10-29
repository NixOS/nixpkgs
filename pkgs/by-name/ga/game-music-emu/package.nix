{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "0.6.4";
  pname = "game-music-emu";

  src = fetchFromGitHub {
    owner = "libgme";
    repo = "game-music-emu";
    tag = version;
    hash = "sha256-qGNWFFUUjv2R5e/nQrriAyDJCARISqNB8e5/1zEJ3fk=";
  };
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

  meta = {
    homepage = "https://github.com/libgme/game-music-emu/";
    description = "Collection of video game music file emulators";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
