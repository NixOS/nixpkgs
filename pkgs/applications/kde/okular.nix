{
  stdenv, mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  breeze-icons, chmlib ? null, discount, djvulibre, ebook_tools, kactivities,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, kdegraphics-mobipocket, kiconthemes, kjs, khtml, kio, kparts,
  kpty, kwallet, kwindowsystem, libkexiv2, libspectre, libzip, phonon, poppler,
  qca-qt5, qtdeclarative, qtsvg, threadweaver, kcrash
}:

mkDerivation {
  name = "okular";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    breeze-icons discount djvulibre ebook_tools kactivities karchive kbookmarks
    kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdegraphics-mobipocket kiconthemes kjs khtml kio kparts kpty kwallet
    kwindowsystem libkexiv2 libspectre libzip phonon poppler qca-qt5
    qtdeclarative qtsvg threadweaver kcrash
  ] ++ lib.optional (!stdenv.isAarch64) chmlib;
  meta = with lib; {
    homepage = "http://www.kde.org";
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ ttuegel turion ];
    platforms = lib.platforms.linux;
  };
}
