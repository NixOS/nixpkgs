{
  lib,
  stdenv,
  fetchurl,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jpeginfo";
  version = "1.7.1";

  src = fetchurl {
    url = "https://www.kokkonen.net/tjko/src/jpeginfo-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-J09r4j/Qib2ehxW2dkOmbKL2OlAwKL3qPlcSKNULZp4=";
  };

  buildInputs = [ libjpeg ];

  meta = {
    description = "Prints information and tests integrity of JPEG/JFIF files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.bjornfor ];
    platforms = lib.platforms.all;
    mainProgram = "jpeginfo";
  };
})
