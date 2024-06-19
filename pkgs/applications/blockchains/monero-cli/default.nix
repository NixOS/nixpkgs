{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, boost, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, randomx, rapidjson
, CoreData, IOKit, PCSC
, trezorSupport ? true, libusb1, protobuf, python3
}:

let
  # submodules
  supercop = fetchFromGitHub {
    owner = "monero-project";
    repo = "supercop";
    rev = "633500ad8c8759995049ccd022107d1fa8a1bbc9";
    hash = "sha256-26UmESotSWnQ21VbAYEappLpkEMyl0jiuCaezRYd/sE=";
  };
  trezor-common = fetchFromGitHub {
    owner = "trezor";
    repo = "trezor-common";
    rev = "bc28c316d05bf1e9ebfe3d7df1ab25831d98d168";
    hash = "sha256-F1Hf1WwHqXMd/5OWrdkpomszACTozDuC7DQXW3p6248=";
  };

in

stdenv.mkDerivation rec {
  pname = "monero-cli";
  version = "0.18.3.3";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    hash = "sha256-1LkKIrud317BEE+713t5wiJV6FcDlJdj4ypXPR0bKTs=";
  };

  patches = [
    ./use-system-libraries.patch
  ];

  postPatch = ''
    # manually install submodules
    rmdir external/{supercop,trezor-common}
    ln -sf ${supercop} external/supercop
    ln -sf ${trezor-common} external/trezor-common
    # export patched source for monero-gui
    cp -r . $source
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    protobuf
  ] ++ lib.optionals stdenv.isDarwin [ IOKit CoreData PCSC ]
    ++ lib.optionals trezorSupport [ libusb1 protobuf python3 ];

  cmakeFlags = [
    "-DUSE_DEVICE_TREZOR=ON"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DRandomX_ROOT_DIR=${randomx}"
  ] ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  outputs = [ "out" "source" ];

  meta = with lib; {
    description = "Private, secure, untraceable currency";
    homepage    = "https://getmonero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
    mainProgram = "monero-wallet-cli";
  };
}
