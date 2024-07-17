{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  ninja,
  pkg-config,
  boost,
  miniupnpc,
  openssl,
  unbound,
  zeromq,
  pcsclite,
  readline,
  libsodium,
  hidapi,
  randomx,
  rapidjson,
  CoreData,
  IOKit,
  PCSC,
  trezorSupport ? true,
  libusb1,
  protobuf,
  python3,
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
    # cmake: remove unused/extera cmake/FindMiniupnpc.cmake and only rely on external/miniupnpc
    # https://github.com/monero-project/monero/pull/9366
    (fetchpatch2 {
      url = "https://github.com/monero-project/monero/commit/5074a543a49f7e23fb39b6462fd4c4c9741c3693.patch?full_index=1";
      hash = "sha256-dS2hhEU6m2of0ULlsf+/tZMHUmq3vGGXJPGHvtnpQnY=";
    })

    # cmake: add different parameters to add_monero_library.
    # https://github.com/monero-project/monero/pull/9367
    (fetchpatch2 {
      url = "https://github.com/monero-project/monero/commit/b91ead90254ac6d6daf908f689c38e372a44c615.patch?full_index=1";
      hash = "sha256-DL2YqkvEONbeEDqLOAo2eSF5JF5gOzKcLKeNlUXBY1w=";
    })

    # external: update miniupnpc to 2.2.8
    # https://github.com/monero-project/monero/pull/9367
    (fetchpatch2 {
      url = "https://github.com/monero-project/monero/commit/d81da086ec5088a04b3f7b34831e72910300e2f7.patch?full_index=1";
      hash = "sha256-ZJGiDMk5DMmEXwzoUYPC+DIoebluFh54kMQtQU78ckI=";
      excludes = [ "external/miniupnp" ];
    })

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
    ninja
    pkg-config
  ];

  buildInputs =
    [
      boost
      miniupnpc
      openssl
      unbound
      zeromq
      pcsclite
      readline
      libsodium
      hidapi
      randomx
      rapidjson
      protobuf
    ]
    ++ lib.optionals stdenv.isDarwin [
      IOKit
      CoreData
      PCSC
    ]
    ++ lib.optionals trezorSupport [
      libusb1
      protobuf
      python3
    ];

  cmakeFlags = [
    "-DUSE_DEVICE_TREZOR=ON"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DRandomX_ROOT_DIR=${randomx}"
  ] ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  outputs = [
    "out"
    "source"
  ];

  meta = with lib; {
    description = "Private, secure, untraceable currency";
    homepage = "https://getmonero.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
    mainProgram = "monero-wallet-cli";
  };
}
