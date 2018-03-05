{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  chmlib, discount, djvulibre, ebook_tools, kactivities, karchive, kbookmarks,
  kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdegraphics-mobipocket, kiconthemes, kjs, khtml, kio, kparts, kpty, kwallet,
  kwindowsystem, libkexiv2, libspectre, libzip, phonon, poppler, qca-qt5,
  qtdeclarative, qtsvg, threadweaver
}:

mkDerivation {
  name = "okular";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    chmlib discount djvulibre ebook_tools kactivities karchive kbookmarks
    kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdegraphics-mobipocket kiconthemes kjs khtml kio kparts kpty kwallet
    kwindowsystem libkexiv2 libspectre libzip phonon poppler qca-qt5
    qtdeclarative qtsvg threadweaver
  ];
  meta = with lib; {
    homepage = http://www.kde.org;
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = lib.platforms.linux;
  };
}
