{
  lib,
  stdenv,
  fetchurl,
  extra-cmake-modules,
  kdoctools,
  wrapQtAppsHook,
  qtscript,
  kconfig,
  kinit,
  karchive,
  kcrash,
  kcmutils,
  kconfigwidgets,
  knewstuff,
  kparts,
  qca-qt5,
  shared-mime-info,
}:

stdenv.mkDerivation rec {
  pname = "okteta";
  version = "0.26.24";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-MbIyPwL01PyHLD/BNdVLuQklglaB5ZHdJfSmgMDSZWo=";
  };

  nativeBuildInputs = [
    qtscript
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  buildInputs = [ shared-mime-info ];

  propagatedBuildInputs = [
    kconfig
    kinit
    kcmutils
    kconfigwidgets
    knewstuff
    kparts
    qca-qt5
    karchive
    kcrash
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    license = lib.licenses.gpl2;
    description = "Hex editor";
    homepage = "https://apps.kde.org/okteta/";
    maintainers = with lib.maintainers; [
      peterhoeg
      bkchr
    ];
    platforms = lib.platforms.linux;
  };
}
