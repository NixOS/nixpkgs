{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "lsscsi";
  version = "0.32";

  src = fetchurl {
    url = "https://sg.danny.cz/scsi/lsscsi-${version}.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
