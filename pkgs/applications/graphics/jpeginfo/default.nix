{
  lib,
  stdenv,
  fetchurl,
  libjpeg,
}:

stdenv.mkDerivation rec {
  pname = "jpeginfo";
  version = "1.7.1";

  src = fetchurl {
    url = "https://www.kokkonen.net/tjko/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-J09r4j/Qib2ehxW2dkOmbKL2OlAwKL3qPlcSKNULZp4=";
  };

  buildInputs = [ libjpeg ];

  meta = with lib; {
    description = "Prints information and tests integrity of JPEG/JFIF files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.all;
    mainProgram = "jpeginfo";
  };
}
