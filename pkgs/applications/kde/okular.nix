{
  stdenv, mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  breeze-icons, chmlib ? null, discount, djvulibre, ebook_tools, kactivities,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, kdegraphics-mobipocket, kiconthemes, kjs, khtml, kio, kparts,
  kpty, kpurpose, kwallet, kwindowsystem, libkexiv2, libspectre, libzip, phonon, poppler,
  qca-qt5, qtdeclarative, qtsvg, threadweaver, kcrash, qtspeech
}:

mkDerivation {
  pname = "okular";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    breeze-icons discount djvulibre ebook_tools kactivities karchive kbookmarks
    kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdegraphics-mobipocket kiconthemes kjs khtml kio kparts kpty kpurpose kwallet
    kwindowsystem libkexiv2 libspectre libzip phonon poppler qca-qt5
    qtdeclarative qtsvg threadweaver kcrash qtspeech
  ] ++ lib.optional (!stdenv.isAarch64) chmlib;

  # InitialPreference values are too high and end up making okular
  # default for anything considered text/plain. Resetting to 1, which
  # is the default.
  postPatch = ''
    substituteInPlace generators/txt/okularApplication_txt.desktop \
      --replace InitialPreference=3 InitialPreference=1
  '';

  meta = with lib; {
    homepage = "http://www.kde.org";
    description = "KDE document viewer";
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ ttuegel turion ];
    platforms = lib.platforms.linux;
  };
}
