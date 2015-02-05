{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pstree-2.36";

  src = fetchurl {
    url = "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz";
    sha256 = "1vx4fndmkkx3bmcv71rpzjjbn24hlfs10pl99dsfhbx16a2d41cx";
  };

  unpackPhase = "unpackFile \$src; sourceRoot=.";

  buildPhase = "pwd; $CC -o pstree pstree.c";
  installPhase = "mkdir -p \$out/bin; cp pstree \$out/bin";

  meta = {
    description = "Show the set of running processes as a tree";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
