{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pstree-2.33";

  src = fetchurl {
    url = "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz";
    sha256 = "1469lrhpy6wghlvbjx6lmvh27rakq00x11cpz4n965fg11i121hg";
  };

  unpackPhase = "unpackFile \$src; sourceRoot=.";

  buildPhase = "pwd; gcc -o pstree pstree.c";
  installPhase = "mkdir -p \$out/bin; cp pstree \$out/bin";

  meta = {
    description = "Show the set of running processes as a tree";
    license = "GPL";
  };
}
