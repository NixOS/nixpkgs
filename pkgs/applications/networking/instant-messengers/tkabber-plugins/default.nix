{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tkabber-plugins-${version}";
  version = "0.11.1";

  src = fetchurl {
    url = "http://files.jabber.ru/tkabber/tkabber-plugins-${version}.tar.gz";
    sha256 = "0jxriqvsckbih5a4lpisxy6wjw022wsz5j5n171gz0q3xw19dbgz";
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
