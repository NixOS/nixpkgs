{ stdenv, fetchurl, gd, ncurses }:

stdenv.mkDerivation rec {
  name = "vnstat-${version}";
  version = "1.15";

  src = fetchurl {
    sha256 = "0fdw3nbrfm4acv48r0934ls6ld5lwkff3gyym2c72qlbm9dlp0f3";
    url = "http://humdi.net/vnstat/${name}.tar.gz";
  };

  buildInputs = [ gd ncurses ];

  postPatch = ''
    substituteInPlace src/cfg.c --replace /usr/local $out
  '';

  meta = with stdenv.lib; {
    description = "Console-based network statistics utility for Linux";
    longDescription = ''
      vnStat is a console-based network traffic monitor for Linux and BSD that
      keeps a log of network traffic for the selected interface(s). It uses the
      network interface statistics provided by the kernel as information source.
      This means that vnStat won't actually be sniffing any traffic and also
      ensures light use of system resources.
    '';
    homepage = http://humdi.net/vnstat/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.linux;
  };
}
