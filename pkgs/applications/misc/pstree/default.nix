args: with args;
stdenv.mkDerivation rec {
  name = "pstree-2.33";

  src = fetchurl {
    url = "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz";
    sha256 = "1469lrhpy6wghlvbjx6lmvh27rakq00x11cpz4n965fg11i121hg";
  };

  unpackPhase="unpackFile \$src; sourceRoot=.";

  buildPhase="pwd; gcc -o pstree pstree.c";
  installPhase="ensureDir \$out/bin; cp pstree \$out/bin";

  meta = {
      description = "show the running processes as tree";
      # don't know the correct homepage..
      homepage = http://fresh.t-systems-sfr.com/unix/src/misc/pstree-2.32.tar.gz;
      license = "GPL";
    };
}
