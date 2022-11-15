{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, qmake
, qttools
, cmake
, clang_8
, grpc
, protobuf
, openssl
, pkg-config
, c-ares
, libGL
, zlib
, curl
}:

mkDerivation rec {
  pname = "qv2ray";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Qv2ray";
    repo = "Qv2ray";
    rev = "v${version}";
    sha256 = "sha256-afFTGX/zrnwq/p5p1kj+ANU4WeN7jNq3ieeW+c+GO5M=";
    fetchSubmodules = true;
  };

  patchPhase = lib.optionals stdenv.isDarwin ''
    substituteInPlace cmake/platforms/macos.cmake \
      --replace \''${QV2RAY_QtX_DIR}/../../../bin/macdeployqt macdeployqt
  '';

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
    c-ares
  ];

  nativeBuildInputs = [
    cmake

    # The default clang_7 will result in reproducible ICE.
    clang_8

    pkg-config
    qmake
    qttools
    curl
  ];

  meta = with lib; {
    description = "An GUI frontend to v2ray";
    homepage = "https://qv2ray.github.io/en/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.all;
  };
}
