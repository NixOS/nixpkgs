{
  lib,
  stdenv,
  cmake,
  ninja,
  kdePackages,
  libsForQt5,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qtengine";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kossLAN";
    repo = "qtengine";
    tag = finalAttrs.version;
    hash = "sha256-aJ5ZdIX10nmhzMLjP6QMuFJHvljJD+xcojuKZjPkr70=";
  };

  outputs = [
    "out"
    "qt5"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.kconfig
    kdePackages.kcolorscheme
    kdePackages.kiconthemes
  ];

  # Workaround for Qt5/Qt6 dual support, similar to breeze (pkgs/kde/plasma/breeze)
  cmakeFlags = [
    "-DQT6_PLUGINDIR=${placeholder "out"}/${kdePackages.qtbase.qtPluginPrefix}"
    "-DQT5_PLUGINDIR=${placeholder "qt5"}/${libsForQt5.qtbase.qtPluginPrefix}"
    "-DQT5_LIBDIR=${placeholder "qt5"}/lib"
    "-DQt5_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5"
    "-DQt5Core_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Core"
    "-DQt5DBus_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5DBus"
    "-DQt5Gui_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Gui"
    "-DQt5Widgets_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Widgets"
    "-DQt5Xml_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Xml"
    "-DQt5ThemeSupport_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5ThemeSupport"
    "-DQt5ThemeSupport_LIBRARY=${libsForQt5.qtbase.out}/lib/libQt5ThemeSupport.a"
    "-DQt5ThemeSupport_INCLUDE_DIR=${libsForQt5.qtbase.dev}/include/QtThemeSupport/${libsForQt5.qtbase.version}"
    "-DQt5Network_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Network"
    "-DQt5Qml_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Qml"
    "-DQt5Quick_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Quick"
    "-DQt5QmlModels_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5QmlModels"
    "-DQt5QuickControls2_DIR=${libsForQt5.qtquickcontrols2.dev}/lib/cmake/Qt5QuickControls2"

    "-DKF5Auth_DIR=${libsForQt5.kauth.dev}/lib/cmake/KF5Auth"
    "-DKF5Codecs_DIR=${libsForQt5.kcodecs.dev}/lib/cmake/KF5Codecs"
    "-DKF5Config_DIR=${libsForQt5.kconfig.dev}/lib/cmake/KF5Config"
    "-DKF5ConfigWidgets_DIR=${libsForQt5.kconfigwidgets.dev}/lib/cmake/KF5ConfigWidgets"
    "-DKF5CoreAddons_DIR=${libsForQt5.kcoreaddons.dev}/lib/cmake/KF5CoreAddons"
    "-DKF5GuiAddons_DIR=${libsForQt5.kguiaddons.dev}/lib/cmake/KF5GuiAddons"
    "-DKF5IconThemes_DIR=${libsForQt5.kiconthemes.dev}/lib/cmake/KF5IconThemes"
    "-DKF5WidgetsAddons_DIR=${libsForQt5.kwidgetsaddons.dev}/lib/cmake/KF5WidgetsAddons"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Minimal Qt platform theme";
    homepage = "https://github.com/kossLAN/qtengine";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kosslan ];
  };
})
