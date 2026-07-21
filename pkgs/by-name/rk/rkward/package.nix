{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  gettext,
  rWrapper,
  rPackages,
  pandoc,
  kdePackages,
  qt6,
  kdsingleapplication,
  shared-mime-info,
  rEnv ? rWrapper.override {
    packages = with rPackages; [
      R2HTML
      rmarkdown
    ];
  },
}:

stdenv.mkDerivation rec {
  pname = "rkward";
  version = "0.8.3";

  src = fetchurl {
    url = "mirror://kde/stable/rkward/${version}/rkward-${version}.tar.gz";
    hash = "sha256-QNKmtt3HfLImzNlwNzUCNcoS06Qi8xsfmuPAG+Qn9eU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
    kdePackages.kdoctools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    rEnv
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebengine
    qt6.qtwebview
    qt6.qtsvg
    kdePackages.breeze-icons
    kdePackages.karchive
    kdePackages.kcompletion
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.ki18n
    kdePackages.kio
    kdePackages.kjobwidgets
    kdePackages.knotifications
    kdePackages.kparts
    kdePackages.kservice
    kdePackages.ktexteditor
    kdePackages.kwidgetsaddons
    kdePackages.kwindowsystem
    kdePackages.kxmlgui
    kdsingleapplication
    shared-mime-info
  ];

  cmakeFlags = [
    "-DDLOPEN_RLIB=OFF"
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ pandoc ]}"
    # Also missing KBibTeX as runtime dep, but it's deprecated in NixOS
  ];

  meta = with lib; {
    description = "Easily extensible and easy-to-use IDE/GUI for R";
    longDescription = ''
      RKWard aims to become an easy to use, transparent frontend to R,
      a powerful system for statistical computation and graphics.
      Besides a convenient GUI for the most important statistical functions,
      future versions will also provide seamless integration with an office-suite.
    '';
    homepage = "https://rkward.kde.org/";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      mit
      bsd3
      cc0
      fdl12Only
    ];
    maintainers = [ maintainers.aliheidary1381 ];
    mainProgram = "rkward";
    platforms = platforms.linux;
  };
}
