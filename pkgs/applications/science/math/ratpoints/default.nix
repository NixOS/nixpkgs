{ stdenv, fetchurl, fetchpatch, gmp }:
stdenv.mkDerivation rec {
  name = "ratpoints-${version}";
  version = "2.1.3.p4";

  src = fetchurl {
    url = "http://www.mathe2.uni-bayreuth.de/stoll/programs/ratpoints-${version}.tar.gz";
    sha256 = "0zhad84sfds7izyksbqjmwpfw4rvyqk63yzdjd3ysd32zss5bgf4";
  };

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ratpoints/patches/sturm_and_rp_private.patch?id=1615f58890e8f9881c4228c78a6b39b9aab1303a";
      sha256 = "0q3wajncyfr3gahd8gwk9x7g56zw54lpywrl63lqk7drkf60mrcl";
    })
  ];

  buildInputs = [ gmp ];

  makeFlags = [ "CC=cc" ];
  buildFlags = stdenv.lib.optional stdenv.isDarwin ["CCFLAGS2=-lgmp -lc -lm" "CCFLAGS=-UUSE_SSE"];
  installFlags = [ "INSTALL_DIR=$(out)" ];

  preInstall = ''mkdir -p "$out"/{bin,share,lib,include}'';

  meta = {
    inherit version;
    description = ''A program to find rational points on hyperelliptic curves'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = http://www.mathe2.uni-bayreuth.de/stoll/programs/;
    updateWalker = true;
  };
}
