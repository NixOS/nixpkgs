{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  qt5,
  zsync2,
  libcpr,
  libgcrypt,
  libappimage,
  argagg,
  nlohmann_json,
  gpgme,
  appimageupdate-qt,
  withQtUI ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appimageupdate";
  version = "2.0.0-alpha-1-20230526";

  src = fetchFromGitHub {
    owner = "AppImageCommunity";
    repo = "AppImageUpdate";
    rev = finalAttrs.version;
    hash = "sha256-b2RqSw0Ksn9OLxQV9+3reBiqrty+Kx9OwV93jlvuPnY=";
  };

  patches = [
    (fetchpatch {
      name = "include-algorithm-header.patch";
      url = "https://github.com/AppImageCommunity/AppImageUpdate/commit/5e91de84aba775ba8d3a4771e4f7f06056f9b764.patch";
      hash = "sha256-RX2HFAlGsEjXona7cL3WdwwiiA0u9CnfvHMC6S0DeLY=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'VERSION 1-alpha' 'VERSION ${finalAttrs.version}' \
      --replace-fail 'env LC_ALL=C date -u "+%Y-%m-%d %H:%M:%S %Z"' 'bash -c "echo 1970-01-01 00:00:01 UTC"' \
      --replace-fail 'git rev-parse --short HEAD' 'bash -c "echo unknown"' \
      --replace-fail '<local dev build>' '<nixpkgs build>'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withQtUI [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    zsync2
    libcpr
    libgcrypt
    libappimage
    argagg
    nlohmann_json
    gpgme
  ]
  ++ lib.optionals withQtUI [
    qt5.qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZSYNC2" true)
    (lib.cmakeBool "USE_SYSTEM_LIBAPPIMAGE" true)
    (lib.cmakeBool "BUILD_QT_UI" withQtUI)
  ];

  dontWrapQtApps = true;

  preFixup = lib.optionalString withQtUI ''
    wrapQtApp "$out/bin/AppImageUpdate"
  '';

  passthru.tests = {
    inherit appimageupdate-qt;
  };

  meta = {
    description = "Update AppImages using information embedded in the AppImage itself";
    homepage = "https://github.com/AppImageCommunity/AppImageUpdate";
    license = lib.licenses.mit;
    mainProgram = if withQtUI then "AppImageUpdate" else "appimageupdatetool";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
