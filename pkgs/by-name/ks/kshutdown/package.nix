{
  stdenv,
  lib,
  fetchurl,
  cmake,
  unzip,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kshutdown";
  version = "6.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/kshutdown/KShutdown/${finalAttrs.version}/kshutdown-source-${finalAttrs.version}.zip";
    hash = "sha256-wV9CWS2I5DGt6oolXAyUqvN4OkV8M3MumflveGlNg5Y=";
    name = "kshutdown-source-${finalAttrs.version}.zip";
  };

  nativeBuildInputs = [
    cmake
    unzip
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    kxmlgui
    knotifyconfig
    kidletime
    kstatusnotifieritem
  ];

  meta = {
    homepage = "https://kshutdown.sourceforge.io/";
    description = "Graphical shutdown utility for Linux and Windows";
    mainProgram = "kshutdown";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
  };
})
