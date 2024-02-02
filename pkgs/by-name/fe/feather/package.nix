{ bc-ur
, boost
, cmake
, fetchFromGitHub
, hidapi
, lib
, libsodium
, libusb1
, openssl
, pkg-config
, protobuf
, qrencode
, qt6
, readline
, stdenv
, testers
, tor
, unbound
, zxing-cpp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feather";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "feather-wallet";
    repo = "feather";
    rev = finalAttrs.version;
    hash = "sha256-23rG+12pAw33rm+jDu9pp8TsumNYh+UbnbeEKs4yB+M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    bc-ur
    boost
    hidapi
    libsodium
    libusb1
    openssl
    protobuf
    qrencode
    unbound
    zxing-cpp
  ] ++ (with qt6; [
    qtbase
    qtmultimedia
    qtsvg
    qttools
    qtwayland
    qtwebsockets
  ]);

  cmakeFlags = [
    "-DProtobuf_INCLUDE_DIR=${lib.getDev protobuf}/include"
    "-DProtobuf_PROTOC_EXECUTABLE=${lib.getExe protobuf}"
    "-DReadline_INCLUDE_DIR=${lib.getDev readline}/include/readline"
    "-DReadline_LIBRARY=${lib.getLib readline}/lib/libreadline.so"
    "-DReadline_ROOT_DIR=${lib.getDev readline}"
    "-DTOR_DIR=${lib.makeBinPath [ tor ]}"
    "-DTOR_VERSION=${tor.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = ''
      QT_QPA_PLATFORM=minimal ${finalAttrs.finalPackage.meta.mainProgram} --version
    '';
  };

  meta = with lib; {
    description = "A free Monero desktop wallet";
    homepage = "https://featherwallet.org/";
    changelog = "https://featherwallet.org/changelog/#${finalAttrs.version}%20changelog";
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "feather";
    maintainers = with maintainers; [ surfaceflinger ];
  };
})
