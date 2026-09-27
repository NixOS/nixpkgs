{
  lib,
  stdenv,
  fetchurl,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtools";
  version = "4.0.49";

  src = fetchurl {
    url = "mirror://gnu/mtools/mtools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-b+UZNYPW58Wdp15j1yNPdsCwfK8zsQOJT0b2aocf/J8=";
  };

  outputs = [
    "out"
    "info"
    "man"
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://www.gnu.org/software/mtools/";
    description = "Utilities to access MS-DOS disks";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Only;
  };
})
