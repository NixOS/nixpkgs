{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, geoip, gperftools, python, swig }:

stdenv.mkDerivation rec {
  name = "bro-2.6.2";

  src = fetchurl {
    url = "https://www.bro.org/downloads/${name}.tar.gz";
    sha256 = "19n0xai1mndx2i28q9cnszam57r6p6zqhprxxfpxh7bv7xpqgxkd";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap perl zlib curl geoip gperftools python swig ];

  # Indicate where to install the python bits, since it can't put them in the "usual"
  # locations as those paths are read-only.
  cmakeFlags = [ "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = https://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
