{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  zlib,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hatari";
  version = "2.6.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "hatari";
    repo = "hatari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KXnLsDmvLPzXsRE1QSymzcx/aX7kNxXSWYcZ2qZ0pw=";
  };

  # For pthread_cancel
  cmakeFlags = [ "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    SDL2
  ];

  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Atari ST/STE/TT/Falcon emulator";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
