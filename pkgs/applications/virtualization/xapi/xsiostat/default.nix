{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xsiostat-0.2.0";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/xenserver/xsiostat/archive/0.2.0/xsiostat-0.2.0.tar.gz";
    sha256 = "1siysvl81z0wgqnnawi1igivw1gjh7ilbfybicr90x2g8yipaq95";
  };

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/sbin
    install -m 0755 xsiostat $out/sbin/xsiostat
    '';

  meta = {
    homepage = https://github.com/xenserver/xsiostat;
    description = "XenServer IO stat thingy";
    license = stdenv.lib.licenses.lgpl21;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
