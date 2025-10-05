{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "micro-httpd";
  version = "20140814";

  src = fetchurl {
    url = "https://acme.com/software/micro_httpd/micro_httpd_14Aug2014.tar.gz";
    sha256 = "0mlm24bi31s0s8w55i0sysv2nc1n2x4cfp6dm47slz49h2fz24rk";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR="$out/bin" MANDIR="$out/share/man/man8")
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
  '';

  meta = with lib; {
    homepage = "http://acme.com/software/micro_httpd/";
    description = "Really small HTTP server";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ ];
    mainProgram = "micro_httpd";
  };
}
