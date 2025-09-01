{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libsForQt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ktextaddons";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-mB7Hh2Ljrg8D2GxDyHCa1s6CVmg5DDkhwafEqtSqUeM=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ (with libsForQt5; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  buildInputs = with libsForQt5; [
    karchive
    kconfigwidgets
    kcoreaddons
    ki18n
    kxmlgui
    qtkeychain
  ];

  meta = {
    description = "Various text handling addons for KDE applications";
    homepage = "https://invent.kde.org/libraries/ktextaddons/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
