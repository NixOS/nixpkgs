{ lib, stdenv, fetchFromGitHub, cmake, ninja, pkg-config
, boost, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, randomx, rapidjson, easyloggingpp
, CoreData, IOKit, PCSC
, trezorSupport ? true, libusb1, protobuf, python3
, monero-cli
}:

stdenv.mkDerivation rec {
  pname = "haven-cli";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "haven-protocol-org";
    repo = "haven-main";
    rev = "v${version}";
    hash = "sha256-XjRxpUW7NC12T5G7fol4avWLJDOOawxJbAHOp5eZ0Fk=";
    fetchSubmodules = true;
  };

  inherit (monero-cli) patches;

  postPatch = ''
    # remove vendored libraries
    rm -r external/{miniupnp,randomx,rapidjson}
    # export patched source for haven-gui
    cp -r . $source
  '';

  nativeBuildInputs = [ cmake ninja pkg-config ];

  buildInputs = [
    boost miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    protobuf readline easyloggingpp
  ] ++ lib.optionals stdenv.isDarwin [ IOKit CoreData PCSC ]
    ++ lib.optionals trezorSupport [ libusb1 protobuf python3 ];

  cmakeFlags = [
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DReadline_INCLUDE_DIR=${readline.dev}/include/readline"
    "-DRandomX_ROOT_DIR=${randomx}"
  ] ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF"
    ++ lib.optional (!trezorSupport) "-DUSE_DEVICE_TREZOR=OFF";

  outputs = [ "out" "source" ];

  meta = with lib; {
    description  = "Haven Protocol is the world's only network of private stable asset";
    homepage     = "https://havenprotocol.org/";
    license      = licenses.bsd3;
    platforms    = platforms.all;
    badPlatforms = [ "x86_64-darwin" ];
    maintainers  = with maintainers; [ kim0 ];
    mainProgram  = "haven-wallet-cli";
  };
}
