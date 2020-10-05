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
## zeek plugin dep
, caf, rdkafka, postgresql, libnghttp2, brotli
, callPackage
, PostgresqlPlugin ? false
, Http2Plugin ? false
, KafkaPlugin ? false
, zeekctl ? true
}:
let
  preConfigure = (import ./script.nix {inherit coreutils;});

  pname = "zeek";
  version = "3.2.1";

  confdir = "/var/lib/${pname}";

  plugin = callPackage ./plugin.nix {
    inherit zeekctl confdir
      rdkafka postgresql  PostgresqlPlugin KafkaPlugin Http2Plugin;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "0rybs79h0sq12vsayah8dixqac404z84rlvqynvzf3dh2lwcgg0y";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig caf ]
                ++ stdenv.lib.optionals KafkaPlugin
                  [ rdkafka ]
                ++ stdenv.lib.optionals PostgresqlPlugin
                  [ postgresql ]
                ++ stdenv.lib.optionals Http2Plugin
                  [ libnghttp2 brotli ] ++
                stdenv.lib.optionals stdenv.isDarwin [ gettext ];

  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;

  ZEEK_DIST = "${placeholder "out"}";

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
    "-DINSTALL_ZEEKCTL=true"
    "-DZEEK_ETC_INSTALL_DIR=${placeholder "out"}/etc"
    "-DENABLE_PERFTOOLS=true"
    "-DCAF_ROOT_DIR=${caf}"
  ];

  inherit (plugin) postFixup;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
