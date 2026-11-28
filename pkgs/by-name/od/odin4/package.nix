{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  cryptopp,
  libusb1,
  qt6,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odin4";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "Llucs";
    repo = "odin4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HJeZbGxnbVL7Mxq72ejABBMbJsCA78HM1RcSWcqlfIA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "pkg_check_modules(CRYPTOPP REQUIRED libcrypto++)" "pkg_check_modules(CRYPTOPP REQUIRED libcryptopp)"
  '';

  strictDeps = true;

  __structuredAttrs = true;

  doCheck = true;

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cryptopp
    libusb1
    qt6.qtbase
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "ODIN4_BUILD_GUI" true)
    (lib.cmakeBool "ODIN4_BUILD_TESTS" finalAttrs.doCheck)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/lib/udev/rules.d
    cp -v ${finalAttrs.pname} $out/bin
    cp -v ${finalAttrs.pname}-gui $out/bin
    cp -v ${finalAttrs.src}/udev/60-${finalAttrs.pname}.rules $out/lib/udev/rules.d

    runHook postInstall
  '';

  postFixup = ''
    wrapQtApp $out/bin/odin4-gui
  '';

  meta = {
    description = "odin4 is a flash tool for Samsung devices";
    homepage = "https://github.com/Llucs/odin4";
    license = lib.licenses.asl20;
    mainProgram = "odin4";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hnrch-br
    ];
  };
})
