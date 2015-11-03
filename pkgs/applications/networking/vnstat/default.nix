{stdenv, fetchurl, ncurses}:

let version = "1.14"; in
stdenv.mkDerivation rec {
  name = "vnstat-${version}";

  src = fetchurl {
    sha256 = "11l39qqv5pgli9zzn0xilld67bi5qzxymsn97m4r022xv13jlipq";
    url = "http://humdi.net/vnstat/${name}.tar.gz";
  };

  installPhase = ''
    mkdir -p $out/{bin,sbin} $out/share/man/{man1,man5}
    cp src/vnstat $out/bin
    cp src/vnstatd $out/sbin
    cp man/vnstat.1 man/vnstatd.1 $out/share/man/man1
    cp man/vnstat.conf.5 $out/share/man/man5
  '';

  buildInputs = [ncurses];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://humdi.net/vnstat/;
    license = licenses.gpl2Plus;
    description = "Console-based network statistics utility for Linux";
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.linux;
  };
}
