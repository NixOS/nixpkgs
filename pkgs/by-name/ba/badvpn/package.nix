{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  nss,
  pkg-config,
  nspr,
  bash,
  debug ? false,
}:

stdenv.mkDerivation rec {
  pname = "badvpn";
  version = "1.999.130";

  src = fetchFromGitHub {
    owner = "ambrop72";
    repo = "badvpn";
    tag = version;
    sha256 = "sha256-bLTDpq3ohUP+KooPvhv1/AZfdo0HwB3g9QOuE2E/pmY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    nss
    nspr
  ];

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/sh@${stdenv.shell}@' -i '{}' ';'
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
    cmakeFlagsArray=("-DCMAKE_BUILD_TYPE=" "-DCMAKE_C_FLAGS=-O3 ${
      lib.optionalString (!debug) "-DNDEBUG"
    }");
    sed -e \
      's/cmake_minimum_required(VERSION 2[.]8)/cmake_minimum_required(VERSION 3.5)/' \
      -i CMakeLists.txt
  '';

<<<<<<< HEAD
  meta = {
    description = "Set of network-related (mostly VPN-related) tools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Set of network-related (mostly VPN-related) tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
