{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  boost186,
  libsodium,
  miniupnpc,
  openssl,
  python3,
  randomx,
  rapidjson,
  readline,
  unbound,
  zeromq,

  trezorSupport ? true,
  hidapi,
  libusb1,
  protobuf_21,
  udev,
}:

let
  # submodules; revs are taken from monero repo's `/external` at the given monero version tag.
  supercop = fetchFromGitHub {
    owner = "monero-project";
    repo = "supercop";
    rev = "633500ad8c8759995049ccd022107d1fa8a1bbc9";
    hash = "sha256-26UmESotSWnQ21VbAYEappLpkEMyl0jiuCaezRYd/sE=";
  };
  trezor-common = fetchFromGitHub {
    owner = "trezor";
    repo = "trezor-common";
    rev = "bff7fdfe436c727982cc553bdfb29a9021b423b0";
    hash = "sha256-VNypeEz9AV0ts8X3vINwYMOgO8VpNmyUPC4iY3OOuZI=";
  };
in
stdenv.mkDerivation rec {
  pname = "monero-cli";
  version = "0.18.4.4";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    hash = "sha256-NH15PKlkm9Hpt25iIuUQmhDg+X3Qo+yUAbDY4LNnZdM=";
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

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost186 # uses boost/asio/io_service.hpp
    libsodium
    miniupnpc
    openssl
    randomx
    rapidjson
    readline
    unbound
    zeromq
  ]
  ++ lib.optionals trezorSupport [
    python3
    hidapi
    libusb1
    protobuf_21
  ]
  ++ lib.optionals (trezorSupport && stdenv.hostPlatform.isLinux) [ udev ];

  cmakeFlags = [
    # skip submodules init
    "-DMANUAL_SUBMODULES=ON"
    # required by monero-gui
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-Wno-dev"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DBoost_USE_MULTITHREADED=OFF"
  ++ lib.optional trezorSupport [
    "-DUSE_DEVICE_TREZOR=ON"
  ];

  outputs = [
    "out"
    "source"
  ];

  meta = {
    description = "Private, secure, untraceable currency";
    homepage = "https://getmonero.org/";
    license = lib.licenses.bsd3;

    platforms = with lib.platforms; linux;

    # macOS/ARM has a working `monerod` (at least), but `monero-wallet-cli`
    # segfaults on start after entering the wallet password, when built in release mode.
    # Building the same revision in debug mode to root-cause the above problem doesn't work
    # because of https://github.com/monero-project/monero/issues/9486
    badPlatforms = [ "aarch64-darwin" ];

    maintainers = with lib.maintainers; [
      pmw
      rnhmjoj
    ];
    mainProgram = "monero-wallet-cli";
    # internal build tool generate_translations_header is tricky to compile for the build platform
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
