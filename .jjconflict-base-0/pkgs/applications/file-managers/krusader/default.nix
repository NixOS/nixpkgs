{
  lib,
  stdenv,
  fetchurl,
  extra-cmake-modules,
  kdoctools,
  karchive,
  kconfig,
  kcrash,
  kguiaddons,
  kparts,
  kwindowsystem,
  cmake,
  wrapQtAppsHook,
  qt5compat,
  kstatusnotifieritem,
}:

stdenv.mkDerivation rec {
  pname = "krusader";
  version = "2.9.0";

  src = fetchurl {
    url = "mirror://kde/stable/krusader/${version}/krusader-${version}.tar.xz";
    hash = "sha256-ybeb+t5sxp/g40Hs75Mvysiv2f6U6MvPvXKf61Q5TgQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    karchive
    kconfig
    kcrash
    kguiaddons
    kparts
    kwindowsystem
    qt5compat
    kstatusnotifieritem
  ];

  meta = {
    homepage = "http://www.krusader.org";
    description = "Norton/Total Commander clone for KDE";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sander ];
    mainProgram = "krusader";
  };
}
