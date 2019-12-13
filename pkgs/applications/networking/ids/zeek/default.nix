{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, rocksdb }:

stdenv.mkDerivation rec {
  pname = "zeek";
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.zeek.org/downloads/zeek-${version}.tar.gz";
    sha256 = "1lhik212wrbi092qizc08f3i0b9pj318sxwm0abc5jc3v3pz7x3r";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig rocksdb ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
  ];

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
