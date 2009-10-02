args: with args;
stdenv.mkDerivation rec {
  name = "pstree-2.32";

  src = fetchurl {
    url = "http://fresh.t-systems-sfr.com/unix/src/misc/${name}.tar.gz";
    sha256 = "0k5r6alnc0ch3frvl5bhh2vi91m6aik10pnjfl86qwkdwsr303az";
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
