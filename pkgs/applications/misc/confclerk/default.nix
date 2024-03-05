{ lib, mkDerivation, fetchurl, qtbase, qmake }:

mkDerivation rec {
  pname = "confclerk";
  version = "0.7.1";

  src = fetchurl {
    url = "https://www.toastfreeware.priv.at/tarballs/confclerk/confclerk-${version}.tar.gz";
    sha256 = "0l5i4d6lymh0k6gzihs41x4i8v1dz0mrwpga096af0vchpvlcarg";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/confclerk $out/bin/
  '';

  meta = {
    description = "Offline conference schedule viewer";
    homepage = "http://www.toastfreeware.priv.at/confclerk";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
