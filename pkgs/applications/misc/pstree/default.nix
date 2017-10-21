{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pstree-2.39";

  src = fetchurl {
    urls = [
      "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz"
      "http://distfiles.macports.org/pstree/${name}.tar.gz"
    ];
    sha256 = "17s7v15c4gryjpi11y1xq75022nkg4ggzvjlq2dkmyg67ssc76vw";
  };

  unpackPhase = "unpackFile \$src; sourceRoot=.";

  buildPhase = "pwd; $CC -o pstree pstree.c";
  installPhase = "mkdir -p \$out/bin; cp pstree \$out/bin";

  meta = {
    description = "Show the set of running processes as a tree";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
    platforms = stdenv.lib.platforms.unix;
  };
}
