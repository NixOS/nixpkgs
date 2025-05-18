{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  autoPatchelfHook,
  qt5,
  libcap,
  nlohmann_json,
  cli11,
  gtest,
  tl-expected,
  yaml-cpp,
  libelf,
  ostree,
  libsysprof-capture,
  xz,
  curl,
  libseccomp,
  gpgme,
  libsodium,
  util-linux,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = "linyaps";
    tag = finalAttrs.version;
    hash = "sha256-grQ+iJBLEtwvfSFipZlbWl4ZhIrPXzDZjOSaqKfAzqI=";
  };

  postPatch = ''
    substituteInPlace misc/CMakeLists.txt \
      --replace-fail "/etc/" ''\'''${CMAKE_INSTALL_PREFIX}/etc/'
    substituteInPlace misc/share/applications/linyaps.desktop \
      --replace-fail "/usr/bin/" ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    tl-expected
    yaml-cpp
    nlohmann_json
    cli11
    gtest
    libelf
    ostree
    libsysprof-capture
    xz
    curl
    libcap
    libseccomp
    gpgme
    libsodium
    util-linux
    qt5.qtbase
    (lib.getLib stdenv.cc.cc)
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" false)
    "-Wno-dev"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-Gen Universal Package Manager";
    homepage = "https://github.com/OpenAtom-Linyaps/linyaps";
    mainProgram = "ll-cli";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
