{ stdenv, alsaLib, boost, dbus_glib, fetchsvn, ganv, glibmm, gtk2
, gtkmm, libjack2, pkgconfig, python2
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
    alsaLib boost dbus_glib ganv glibmm gtk2 gtkmm libjack2
    pkgconfig python2
  ];

  configurePhase = "python waf configure --prefix=$out";
  buildPhase = "python waf build";
  installPhase = "python waf install";

  meta = {
    description = "Modular patch bay for Jack and ALSA systems";
    homepage = http://non.tuxfamily.org;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
