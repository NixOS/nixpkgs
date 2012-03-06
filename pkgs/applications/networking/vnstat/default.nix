{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "vnstat-1.9";
  
  src = fetchurl {
    url = http://humdi.net/vnstat/vnstat-1.9.tar.gz;
    sha256 = "1migym0wig1s3b7d22ipxkd1p78sqc89dwx82qbf5hsb5q2fk4q1";
  };

  installPhase = ''
    mkdir -p $out/{bin,sbin} $out/share/man/{man1,man5}
    cp src/vnstat $out/bin
    cp src/vnstatd $out/sbin
    cp man/vnstat.1 man/vnstatd.1 $out/share/man/man1
    cp man/vnstat.conf.5 $out/share/man/man5
  '';

  buildInputs = [ncurses];

  meta = {
    homepage = http://humdi.net/vnstat/;
    license = "GPLv2+";
    description = "Console-based network statistics utility for Linux";
  };
}
