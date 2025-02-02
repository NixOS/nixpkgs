{
  lib,
  stdenv,
  fetchurl,
  cmake,
  removeReferencesTo,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "0.6.3";
  pname = "game-music-emu";

  src = fetchurl {
    url = "https://bitbucket.org/mpyne/game-music-emu/downloads/${pname}-${version}.tar.xz";
    sha256 = "07857vdkak306d9s5g6fhmjyxk7vijzjhkmqb15s7ihfxx9lx8xb";
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
    homepage = "https://bitbucket.org/mpyne/game-music-emu/wiki/Home";
    description = "Collection of video game music file emulators";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
