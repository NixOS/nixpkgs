{ stdenv, fetchFromGitHub, fetchpatch
, cmake, pkgconfig
, boost, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, randomx, rapidjson
, CoreData, IOKit, PCSC
, trezorSupport ? true
,   libusb1  ? null
,   protobuf ? null
,   python3  ? null
}:

with stdenv.lib;

assert stdenv.isDarwin -> IOKit != null;
assert trezorSupport -> all (x: x!=null) [ libusb1 protobuf python3 ];

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.17.1.7";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    sha256 = "1fdw4i4rw87yz3hz4yc1gdw0gr2mmf9038xaw2l4rrk5y50phjp4";
    fetchSubmodules = true;
  };

  patches = [
    ./use-system-libraries.patch
  ];

  postPatch = ''
    # remove vendored libraries
    rm -r external/{miniupnp,randomx,rapidjson,unbound}
    # export patched source for monero-gui
    cp -r . $source
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    protobuf
  ] ++ optionals stdenv.isDarwin [ IOKit CoreData PCSC ]
    ++ optionals trezorSupport [ libusb1 protobuf python3 ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_DEVICE_TREZOR=ON"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DRandomX_ROOT_DIR=${randomx}"
  ] ++ optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  outputs = [ "out" "source" ];

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage    = "https://getmonero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ehmry rnhmjoj ];
  };
}
