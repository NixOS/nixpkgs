{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tkabber-plugins-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://files.jabber.ru/tkabber/tkabber-plugins-${version}.tar.xz";
    sha256 = "d61251dc664f0bfa8534e578096dede9a7bb7d4f2620489f8d2c43d36cd61ba9";
  };

  configurePhase = ''
    sed -e "s@/usr/local@$out@" -i Makefile
  '';

  meta = {
    homepage = "http://tkabber.jabber.ru/tkabber-plugins";
    description = "Plugins for the Tkabber instant messenger";
    license = stdenv.lib.licenses.gpl2;
  };
}
