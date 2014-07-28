{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "vnstat-1.11";

  src = fetchurl {
    url = "http://humdi.net/vnstat/${name}.tar.gz";
    sha256 = "09p0mlf49zzmh6jzwyvzd9k3jv7bl8i6w8xl65ns3dmv2zc7c65p";
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
  };
}
