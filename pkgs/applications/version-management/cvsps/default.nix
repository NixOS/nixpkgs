{ fetchurl, stdenv, cvs, zlib }:

stdenv.mkDerivation rec {
  name = "cvsps-${version}";
  version = "2.1";
  src = fetchurl {
    url = "mirror://debian/pool/main/c/cvsps/cvsps_${version}.orig.tar.gz";
    sha256 = "0nh7q7zcmagx0i63h6fqqkkq9i55k77myvb8h6jn2f266f5iklwi";
  };

  # Patches from Debian's `cvsps-2.1-4'.
  patches = [ ./01_ignoretrunk.dpatch
              ./02_dynamicbufferalloc.dpatch
	      ./03_diffoptstypo.dpatch ];

  buildInputs = [ cvs zlib ];

  installPhase = "make install prefix=$out";

  meta = {
    description = ''A tool to generate CVS patch set information'';
    longDescription = ''
      CVSps is a program for generating `patchset' information from a
      CVS repository.  A patchset in this case is defined as a set of
      changes made to a collection of files, and all committed at the
      same time (using a single "cvs commit" command).
    '';
    homepage = http://www.cobite.com/cvsps/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
