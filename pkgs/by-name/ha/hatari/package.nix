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
  version = "2.6.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "hatari";
    repo = "hatari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hfSlpYwS6PcA4pqpYeFnOptN4hX7ZjLB8cu9cZ8pr7Y=";
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
