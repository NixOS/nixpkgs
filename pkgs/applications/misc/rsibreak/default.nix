{
  fetchurl,
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  kdoctools,
  wrapQtAppsHook,
  knotifyconfig,
  kidletime,
  kwindowsystem,
  kstatusnotifieritem,
  ktextwidgets,
  kcrash,
}:

stdenv.mkDerivation rec {
  pname = "rsibreak";
  version = "0.13.0";

  src = fetchurl {
    url = "mirror://kde/stable/rsibreak/${lib.versions.majorMinor version}/rsibreak-${version}.tar.xz";
    hash = "sha256-arLOCcV9D+UXgwjqlfh9675VrpjPs3QkkireJZO60SA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  propagatedBuildInputs = [
    knotifyconfig
    kidletime
    kwindowsystem
    kstatusnotifieritem
    ktextwidgets
    kcrash
  ];

  meta = {
    description = "Takes care of your health and regularly breaks your work to avoid repetitive strain injury (RSI)";
    mainProgram = "rsibreak";
    license = lib.licenses.gpl2;
    homepage = "https://www.kde.org/applications/utilities/rsibreak/";
    maintainers = with lib.maintainers; [ vandenoever ];
  };
}
