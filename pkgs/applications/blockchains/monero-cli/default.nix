{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  boost,
  libsodium,
  miniupnpc,
  openssl,
  python3,
  randomx,
  rapidjson,
  readline,
  unbound,
  zeromq,

  # darwin
  CoreData,
  IOKit,

  trezorSupport ? true,
  hidapi,
  libusb1,
  protobuf_21,
  udev,
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
  version = "0.18.3.4";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    hash = "sha256-nDiFJjhsISYM8kTgJUaPYL44iyccnz5+Pd5beBh+lsM=";
  };

  patches = [ ./use-system-libraries.patch ];

  postPatch = ''
    # manually install submodules
    rmdir external/{supercop,trezor-common}
    ln -sf ${supercop} external/supercop
    ln -sf ${trezor-common} external/trezor-common
    # export patched source for monero-gui
    cp -r . $source
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      boost
      libsodium
      miniupnpc
      openssl
      randomx
      rapidjson
      readline
      unbound
      zeromq
    ]
    ++ lib.optionals stdenv.isDarwin [
      IOKit
      CoreData
    ]
    ++ lib.optionals trezorSupport [
      python3
      hidapi
      libusb1
      protobuf_21
    ]
    ++ lib.optionals (trezorSupport && stdenv.isLinux) [
      udev
    ];

  cmakeFlags =
    [
      # skip submodules init
      "-DMANUAL_SUBMODULES=ON"
      # required by monero-gui
      "-DBUILD_GUI_DEPS=ON"
      "-DReadline_ROOT_DIR=${readline.dev}"
    ]
    ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF"
    ++ lib.optional trezorSupport [
      "-DUSE_DEVICE_TREZOR=ON"
      # fix build on recent gcc versions
      "-DCMAKE_CXX_FLAGS=-fpermissive"
    ];

  outputs = [ "out" "source" ];

  meta = {
    description = "Private, secure, untraceable currency";
    homepage = "https://getmonero.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    mainProgram = "monero-wallet-cli";
  };
}
