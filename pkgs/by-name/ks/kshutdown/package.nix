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
<<<<<<< HEAD
  version = "6.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/kshutdown/KShutdown/${finalAttrs.version}/kshutdown-source-${finalAttrs.version}.zip";
    hash = "sha256-wV9CWS2I5DGt6oolXAyUqvN4OkV8M3MumflveGlNg5Y=";
=======
  version = "6.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/kshutdown/KShutdown/${finalAttrs.version}/kshutdown-source-${finalAttrs.version}.zip";
    hash = "sha256-GXs0Cb1gtlPy8fxy3CJ10t97BENMWFsRJHij+104BLA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://kshutdown.sourceforge.io/";
    description = "Graphical shutdown utility for Linux and Windows";
    mainProgram = "kshutdown";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://kshutdown.sourceforge.io/";
    description = "Graphical shutdown utility for Linux and Windows";
    mainProgram = "kshutdown";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ eymeric ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
