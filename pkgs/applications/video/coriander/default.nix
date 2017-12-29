{stdenv, fetchurl, pkgconfig, glib, gtk2, libgnomeui, libXv, libraw1394, libdc1394
, SDL, automake, GConf }:

stdenv.mkDerivation rec {
  name = "coriander-2.0.1";

  src = fetchurl {
    url = "http://damien.douxchamps.net/ieee1394/coriander/archives/coriander-2.0.1.tar.gz";
    sha256 = "0l6hpfgy5r4yardilmdrggsnn1fbfww516sk5a90g1740cd435x5";
  };

  preConfigure = ''
    cp ${automake}/share/automake-*/mkinstalldirs .
  '';

  buildInputs = [ pkgconfig glib gtk2 libgnomeui libXv libraw1394 libdc1394 SDL GConf ];
  
  meta = {
    homepage = https://damien.douxchamps.net/ieee1394/coriander/;
    description = "GUI for controlling a Digital Camera through the IEEE1394 bus";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
