{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, pkg-config
, boost179, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, randomx, rapidjson
, easyloggingpp
, CoreData, IOKit, PCSC
, trezorSupport ? true, libusb1, protobuf, python3
}:

stdenv.mkDerivation rec {
  pname = "haven-cli";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "haven-protocol-org";
    repo = "haven-main";
    rev = "v${version}";
    sha256 = "sha256-HLZ9j75MtF7FkHA4uefkrYp07pVZe1Ac1wny7T0CMpA=";
    fetchSubmodules = true;
  };

  patches = [
    ./use-system-libraries.patch
  ];

  postPatch = ''
    # remove vendored libraries
    rm -r external/{miniupnp,randomx,rapidjson,unbound}
    # export patched source for haven-gui
    cp -r . $source
    # fix build on aarch64-darwin
    substituteInPlace CMakeLists.txt --replace "-march=x86-64" ""
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost179 miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    protobuf
    readline easyloggingpp
  ]
    ++ lib.optionals trezorSupport [ libusb1 protobuf python3 ];

  cmakeFlags = [
    "-DUSE_DEVICE_TREZOR=ON"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DReadline_INCLUDE_DIR=${readline.dev}/include/readline"
    "-DRandomX_ROOT_DIR=${randomx}"
  ] ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  outputs = [ "out" "source" ];

  meta = with lib; {
    description = "Haven Protocol is the world's only network of private stable asset";
    homepage    = "https://havenprotocol.org/";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ kim0 ];
  };
}
