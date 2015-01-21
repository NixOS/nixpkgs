{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "vnstat-1.13";

  src = fetchurl {
    url = "http://humdi.net/vnstat/${name}.tar.gz";
    sha256 = "1kcrxpvp3al1j6kh7k69vwva6kd1ba32wglx95gv55dixfcjakkg";
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
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Console-based network statistics utility for Linux";
    maintainers = with stdenv.lib.maintainers; [ nckx ];
  };
}
