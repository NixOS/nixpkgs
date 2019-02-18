{ stdenv, alsaLib, boost, dbus-glib, fetchsvn, ganv, glibmm
, gtkmm2, libjack2, pkgconfig, python2, wafHook
}:

stdenv.mkDerivation rec {
  name = "patchage-${version}";
  version = "1.0.1";
  src = fetchsvn {
    url = http://svn.drobilla.net/lad/trunk/patchage/;
    rev = "5821";
    sha256 = "1ar64l0sg468qzxj7i6ppgfqjpm92awcp5lzskamrf3ln17lrgj7";
  };

  buildInputs = [
    alsaLib boost dbus-glib ganv glibmm gtkmm2 libjack2
    pkgconfig python2 wafHook
  ];

  meta = {
    description = "Modular patch bay for Jack and ALSA systems";
    homepage = http://non.tuxfamily.org;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
