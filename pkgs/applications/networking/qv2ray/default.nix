{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qttools
, cmake
, clang
, grpc
, protobuf
, openssl
, pkg-config
, c-ares
, abseil-cpp
, libGL
, zlib
}:

mkDerivation rec {
  pname = "qv2ray";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "Qv2ray";
    repo = "Qv2ray";
    rev = "v${version}";
    sha256 = "sha256-zf3IlpRbZGDZMEny0jp7S+kWtcE1Z10U9GzKC0W0mZI=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DQV2RAY_DISABLE_AUTO_UPDATE=on"
    "-DQV2RAY_TRANSLATION_PATH=${placeholder "out"}/share/qv2ray/lang"
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
    abseil-cpp
    c-ares
  ];

  nativeBuildInputs = [
    cmake
    clang
    pkg-config
    qmake
    qttools
  ];

  meta = with lib; {
    description = "An GUI frontend to v2ray";
    homepage = "https://qv2ray.github.io/en/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.all;
  };
}
