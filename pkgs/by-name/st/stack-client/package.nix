{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  extra-cmake-modules,
  qt6,
  qt6Packages,
  zlib,
  sqlite,
  kdePackages,
  kdsingleapplication,
  libre-graph-api-cpp-qt-client,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stack-client";
  version = "5.3.1-20240731";

  # Use versioned source instead of unstable "latest" URL
  # Date: 2024-07-31 - verified stable release tarball
  src = fetchurl {
    url = "https://filehosting-client.transip.nl/packages/stack/v${finalAttrs.version}/source/stack-v${finalAttrs.version}.tar.gz";
    hash = "sha256-rGlpntsWGO8JTktkL+csh78V5lAmApSGvvUIJqdG4Zw=";
  };

  sourceRoot = "client";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6Packages.qtkeychain
    kdsingleapplication
    libre-graph-api-cpp-qt-client
    zlib
    sqlite
    kdePackages.kcoreaddons
  ];

  meta = {
    description = "Stack Client for TransIP";
    homepage = "https://www.transip.nl/stack";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.timoteuszelle ];
  };
})
