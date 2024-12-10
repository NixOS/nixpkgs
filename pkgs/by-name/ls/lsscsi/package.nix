{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "lsscsi";
  version = "0.32";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-${version}.tgz";
    sha256 = "sha256-CoAOnpTcoqtwLWXXJ3eujK4Hjj100Ly+1kughJ6AKaE=";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
