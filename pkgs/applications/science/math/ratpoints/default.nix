{ lib, stdenv, fetchurl, fetchpatch, gmp }:
stdenv.mkDerivation rec {
  pname = "ratpoints";
  version = "2.1.3.p4";

  src = fetchurl {
    url = "http://www.mathe2.uni-bayreuth.de/stoll/programs/ratpoints-${version}.tar.gz";
    sha256 = "0zhad84sfds7izyksbqjmwpfw4rvyqk63yzdjd3ysd32zss5bgf4";
  };

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/1615f58890e8f9881c4228c78a6b39b9aab1303a/build/pkgs/ratpoints/patches/sturm_and_rp_private.patch";
      sha256 = "0q3wajncyfr3gahd8gwk9x7g56zw54lpywrl63lqk7drkf60mrcl";
    })
  ];

  buildInputs = [ gmp ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  buildFlags = lib.optionals stdenv.isDarwin ["CCFLAGS2=-lgmp -lc -lm" "CCFLAGS=-UUSE_SSE"];
  installFlags = [ "INSTALL_DIR=$(out)" ];

  preInstall = ''mkdir -p "$out"/{bin,share,lib,include}'';

  meta = {
    description = "A program to find rational points on hyperelliptic curves";
    license = lib.licenses.gpl2Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
    homepage = "http://www.mathe2.uni-bayreuth.de/stoll/programs/";
  };
}
