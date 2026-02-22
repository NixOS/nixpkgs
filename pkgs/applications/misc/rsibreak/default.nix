{
  fetchurl,
  lib,
  stdenv,
  extra-cmake-modules,
  kdoctools,
  wrapQtAppsHook,
  knotifyconfig,
  kidletime,
  kwindowsystem,
  ktextwidgets,
  kcrash,
}:

stdenv.mkDerivation rec {
  pname = "rsibreak";
  version = "0.12.13";

  src = fetchurl {
    url = "mirror://kde/stable/rsibreak/${version}/rsibreak-${version}.tar.xz";
    sha256 = "N0C+f788fq5yotSC54H2K4WDc6PnGi8Nh/vXL4v0fxo=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  propagatedBuildInputs = [
    knotifyconfig
    kidletime
    kwindowsystem
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
