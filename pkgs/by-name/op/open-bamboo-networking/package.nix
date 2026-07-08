# Copyright (c) 2024 Tom Sievers
# SPDX-License-Identifier: MIT
#
# NixOS packaging logic is originally inspired by and adapted from:
# https://codeberg.org/TomSievers/open-bamboo-networking-nixos.git
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  curl,
  uthash,
  client ? "bambu_studio",
  pluginVersion ? "02.05.00.99",
}:

let
  mosquittoSrc = fetchFromGitHub {
    owner = "eclipse";
    repo = "mosquitto";
    rev = "v2.1.2";
    hash = "sha256-Zl55yjuzQY2fyaKs/zLaJ7a3OONKTDQPaT+DpPURdZI=";
  };

  cJsonSrc = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v1.7.18";
    hash = "sha256-UgUWc/+Zie2QNijxKK5GFe4Ypk97EidG8nTiiHhn5Ys=";
  };
in
stdenv.mkDerivation rec {
  pname = "open-bamboo-networking-${client}";
  version = "1.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ClusterM";
    repo = "open-bamboo-networking";
    rev = "v${version}";
    hash = "sha256-bxkOwCnlKu2fA3cEiTZq15anSwLkuJIyko19wqul6Fw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    curl
    uthash
  ];

  cmakeFlags = [
    "-DOBN_VERSION=${pluginVersion}"
    "-DOBN_CLIENT_TYPE=${client}"
    "-DOBN_PATCH_CLIENT_CONF=OFF"
    "-DOBN_BUILD_TESTS=OFF"

    # Prefer a staged Nix install, not ~/.config/BambuStudio
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DFETCHCONTENT_SOURCE_DIR_CJSON=${cJsonSrc}"
  ];

  preConfigure = ''
    cp -r ${mosquittoSrc} $TMPDIR/source/mosquitto-src
    chmod -R u+w $TMPDIR/source/mosquitto-src

    cmakeFlagsArray+=(
      "-DFETCHCONTENT_SOURCE_DIR_ECLIPSE_MOSQUITTO=$TMPDIR/source/mosquitto-src"
    )
  '';

  meta = {
    description = "Open-source Bambu/Orca network plugin replacement";
    homepage = "https://github.com/ClusterM/open-bamboo-networking";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mio ];
    platforms = lib.platforms.linux;
  };
}
