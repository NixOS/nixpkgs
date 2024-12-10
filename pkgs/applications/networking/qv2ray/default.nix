{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  symlinkJoin,
  qttools,
  cmake,
  grpc,
  protobuf,
  openssl,
  pkg-config,
  c-ares,
  libGL,
  zlib,
  curl,
  v2ray,
  v2ray-geoip,
  v2ray-domain-list-community,
  assets ? [
    v2ray-geoip
    v2ray-domain-list-community
  ],
}:

mkDerivation rec {
  pname = "qv2ray";
  version = "unstable-2023-07-11";

  src = fetchFromGitHub {
    owner = "Qv2ray";
    repo = "Qv2ray";
    rev = "b3080564809dd8aef864a54ca1b79f0984fe986b";
    hash = "sha256-LwBjuX5x3kQcdEfPLEirWpkMqOigkhNoh/VNmBfPAzw=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionals stdenv.isDarwin ''
    substituteInPlace cmake/platforms/macos.cmake \
      --replace \''${QV2RAY_QtX_DIR}/../../../bin/macdeployqt macdeployqt
  '';

  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  cmakeFlags = [
    "-DQV2RAY_DISABLE_AUTO_UPDATE=on"
    "-DQV2RAY_USE_V5_CORE=on"
    "-DQV2RAY_TRANSLATION_PATH=${placeholder "out"}/share/qv2ray/lang"
    "-DQV2RAY_DEFAULT_VASSETS_PATH='${assetsDrv}/share/v2ray'"
    "-DQV2RAY_DEFAULT_VCORE_PATH='${v2ray}/bin/v2ray'"
  ];

  preConfigure = ''
    export _QV2RAY_BUILD_INFO_="Qv2ray Nixpkgs"
    export _QV2RAY_BUILD_EXTRA_INFO_="(Nixpkgs build) nixpkgs"
  '';

  buildInputs = [
    libGL
    zlib
    grpc
    protobuf
    openssl
    c-ares
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    curl
  ];

  meta = with lib; {
    description = "An GUI frontend to v2ray";
    homepage = "https://github.com/Qv2ray/Qv2ray";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      poscat
      rewine
    ];
    platforms = platforms.all;
    # never built on aarch64-darwin, x86_64-darwin since update to unstable-2022-09-25
    broken = stdenv.isDarwin;
    mainProgram = "qv2ray";
  };
}
