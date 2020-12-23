{ stdenv
, fetchurl
, cmake
, flex
, bison
, openssl
, libpcap
, zlib
, file
, curl
, libmaxminddb
, gperftools
, python
, swig
, gettext
, fetchpatch
, coreutils
}:
let
  preConfigure = (import ./script.nix {inherit coreutils;});
in
stdenv.mkDerivation rec {
  pname = "zeek";
  version = "3.2.3";

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "1in25clpbb2vdhms3iypj6r5sp8d1dxjcfn85c272sh7shnmqagr";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ gettext ];

  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;

  enableParallelBuilding = true;

  patches = stdenv.lib.optionals stdenv.cc.isClang [
    # Fix pybind c++17 build with Clang. See: https://github.com/pybind/pybind11/issues/1604
    (fetchpatch {
      url = "https://github.com/pybind/pybind11/commit/759221f5c56939f59d8f342a41f8e2d2cacbc8cf.patch";
      sha256 = "17qznp8yavnv84fjsbghv3d59z6k6rx74j49w0izakmgw5a95w84";
      extraPrefix = "auxil/broker/bindings/python/3rdparty/pybind11/";
      stripLen = 1;
    })
  ];

  cmakeFlags = [
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
  ];

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    changelog = "https://github.com/zeek/zeek/blob/v${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
