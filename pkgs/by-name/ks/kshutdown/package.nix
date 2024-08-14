{ stdenv
, lib
, fetchurl
, cmake
, unzip
, kdePackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kshutdown";
  version = "5.92-beta";

  src = fetchurl {
    url = "mirror://sourceforge/project/kshutdown/KShutdown/${finalAttrs.version}/kshutdown-source-${finalAttrs.version}.zip";
    hash = "sha256-EYgb2jeUoLNSPFIzlicnrmsccGc1nvoE5iDVt9x83ns=";
    name = "kshutdown-source-${finalAttrs.version}.zip";
  };

  nativeBuildInputs = [ cmake unzip kdePackages.wrapQtAppsHook ];

  buildInputs = with kdePackages; [ qtbase kxmlgui knotifyconfig kidletime kstatusnotifieritem ];

  meta = with lib; {
    homepage = "https://kshutdown.sourceforge.io/";
    description = "Graphical shutdown utility for Linux and Windows";
    mainProgram = "kshutdown";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers ; [ eymeric ];
    platforms = platforms.linux;
  };
})
