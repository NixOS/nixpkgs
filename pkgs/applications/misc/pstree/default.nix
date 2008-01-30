args: with args;
stdenv.mkDerivation {
  name = "pstree-2.31";

  src = fetchurl {
    url = http://fresh.t-systems-sfr.com/unix/src/misc/pstree-2.31.tar.gz;
    sha256 = "1zzz29gsyra8csk54cyq0pcdxxg3l4gmksq8q1skv2z84g2yxdhh";
  };

  unpackPhase="unpackFile \$src; sourceRoot=.";
  
  buildPhase="pwd; gcc -o pstree pstree.c";
  installPhase="ensureDir \$out/bin; cp pstree \$out/bin";

  meta = { 
      description = "show the running processes as tree";
      # don't know the correct homepage..
      homepage = http://fresh.t-systems-sfr.com/unix/src/misc/pstree-2.31.tar.gz;
      license = "GPL";
    }; 
}
