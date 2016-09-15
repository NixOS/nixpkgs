{ fetchurl, stdenv, intltool, pkgconfig, gtk2, xdotool }:

stdenv.mkDerivation rec {
  name = "clipit-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/downloads/shantzu/ClipIt/${name}.tar.gz";
    sha256 = "0jrwn8qfgb15rwspdp1p8hb1nc0ngmpvgr87d4k3lhlvqg2cfqva";
  };

  buildInputs = [ intltool pkgconfig gtk2 xdotool  ];

  meta = with stdenv.lib; {
    description = "Lightweight GTK+ Clipboard Manager";
    homepage    = "http://clipit.rspwn.com";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
