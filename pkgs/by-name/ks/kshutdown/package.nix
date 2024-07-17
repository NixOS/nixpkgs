{
  stdenv,
  lib,
  fetchurl,
  extra-cmake-modules,
  unzip,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kshutdown";
  version = "5.91-beta";

  src = fetchurl {
    url = "mirror://sourceforge/project/kshutdown/KShutdown/${finalAttrs.version}/kshutdown-source-${finalAttrs.version}.zip";
    hash = "sha256-gWXpVBhoZ57kaQV1C+xCBYc2gZjzJfFViD/SI9D+BRc=";
    name = "kshutdown-source-${finalAttrs.version}.zip";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    unzip
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    qtbase
    kxmlgui
    knotifyconfig
    kidletime
  ];

  meta = with lib; {
    homepage = "https://kshutdown.sourceforge.io/";
    description = "A graphical shutdown utility for Linux and Windows";
    mainProgram = "kshutdown";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ eymeric ];
    platforms = platforms.linux;
  };
})
