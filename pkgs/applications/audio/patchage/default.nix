{ lib, stdenv, alsa-lib, boost, dbus-glib, fetchsvn, ganv, glibmm
, gtkmm2, libjack2, pkg-config, python2, wafHook
}:

stdenv.mkDerivation {
  pname = "patchage";
  version = "1.0.1";
  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/patchage/";
    rev = "5821";
    sha256 = "1ar64l0sg468qzxj7i6ppgfqjpm92awcp5lzskamrf3ln17lrgj7";
  };

  buildInputs = [
    alsa-lib boost dbus-glib ganv glibmm gtkmm2 libjack2
    pkg-config python2 wafHook
  ];

  meta = {
    description = "Modular patch bay for Jack and ALSA systems";
    homepage = "http://non.tuxfamily.org";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
