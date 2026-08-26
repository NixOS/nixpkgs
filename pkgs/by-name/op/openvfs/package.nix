{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fuse3,
  kdePackages,
  nix-update-script,
  nlohmann_json,
  qt6,
}:
#
stdenv.mkDerivation (finalAttrs: {
  pname = "openvfs";
  version = "0.1.0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "openvfs";
    rev = "525d8c6c9158c12604b0aaaedb6bae532804328d";
    hash = "sha256-O/or88niQACm7oA9MGqHZe+cw9XTAzUKhfkBg3fGUz8=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.qtbase
    fuse3
  ];

  buildInputs = [
    fuse3
    nlohmann_json
  ];

  __structuredAttrs = true;
  strictDeps = true;
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeFeature "ECM_DIR" "${kdePackages.extra-cmake-modules}/share/ECM/cmake")
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" false)
    (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${qt6.qtbase}")
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Virtual Filesystem Layer for cloud storages for the free desktop (FUSE based files-on-demand)";
    homepage = "https://github.com/opencloud-eu/openvfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "openvfs";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
