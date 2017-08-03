{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  djvulibre, ebook_tools, kactivities, karchive, kbookmarks, kcompletion,
  kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdegraphics-mobipocket,
  kiconthemes, kjs, khtml, kio, kparts, kpty, kwallet, kwindowsystem, libkexiv2,
  libspectre, phonon, poppler, qca-qt5, qtdeclarative, qtsvg, threadweaver
}:

mkDerivation {
  name = "okular";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    djvulibre ebook_tools kactivities karchive kbookmarks kcompletion kconfig kconfigwidgets
    kcoreaddons kdbusaddons kdegraphics-mobipocket kiconthemes kjs khtml kio
    kparts kpty kwallet kwindowsystem libkexiv2 libspectre phonon poppler
    qca-qt5 qtdeclarative qtsvg threadweaver
  ];
  meta = {
    platforms = lib.platforms.linux;
    homepage = http://www.kde.org;
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
