{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, symlinkJoin
, qttools
, cmake
, clang_8
, grpc
, protobuf
, openssl
, pkg-config
, c-ares
, abseil-cpp
, libGL
, zlib
, curl
, v2ray
, v2ray-geoip, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

mkDerivation rec {
  pname = "qv2ray";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
    owner = "Qv2ray";
    repo = "Qv2ray";
    rev = "fb44fb1421941ab192229ff133bc28feeb4a8ce5";
    sha256 = "sha256-TngDgLXKyAoQFnXpBNaz4QjfkVwfZyuQwatdhEiI57U=";
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
    "-DCMAKE_BUILD_TYPE=Release"
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
    abseil-cpp
    c-ares
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    curl
    # The default clang_7 will result in reproducible ICE.
  ] ++ lib.optional (stdenv.isDarwin) clang_8;

  meta = with lib; {
    description = "An GUI frontend to v2ray";
    homepage = "https://qv2ray.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poscat rewine ];
    platforms = platforms.all;
  };
}
