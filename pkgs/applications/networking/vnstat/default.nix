{ stdenv, fetchurl, pkgconfig, gd, ncurses, sqlite, check }:

stdenv.mkDerivation rec {
  pname = "vnstat";
  version = "2.6";

  src = fetchurl {
    sha256 = "1xvzkxkq1sq33r2s4f1967f4gnca4xw411sbapdkx541f856w9w9";
    url = "https://humdi.net/${pname}/${pname}-${version}.tar.gz";
  };

  postPatch = ''
    substituteInPlace src/cfg.c --replace /usr/local $out
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gd ncurses sqlite ];

  checkInputs = [ check ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Console-based network statistics utility for Linux";
    longDescription = ''
      vnStat is a console-based network traffic monitor for Linux and BSD that
      keeps a log of network traffic for the selected interface(s). It uses the
      network interface statistics provided by the kernel as information source.
      This means that vnStat won't actually be sniffing any traffic and also
      ensures light use of system resources.
    '';
    homepage = https://humdi.net/vnstat/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
