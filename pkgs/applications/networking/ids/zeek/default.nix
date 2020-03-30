{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, rocksdb }:
let
  preConfigure = (import ./script.nix);
in
stdenv.mkDerivation rec {
  pname = "zeek";
  version = "3.0.3";

  src = fetchurl {
    url = "https://old.zeek.org/downloads/zeek-${version}.tar.gz";
    sha256 = "0xlw5v83qbgy23wdcddmvan2pid28mw745g4fc1z5r18kp67i8a2";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig rocksdb ];

  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;
  
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
