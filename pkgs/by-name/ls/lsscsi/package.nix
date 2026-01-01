{
  lib,
  stdenv,
  fetchurl,
}:

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

<<<<<<< HEAD
  meta = {
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
