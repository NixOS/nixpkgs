{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kbookmarks, kconfig, kconfigwidgets, kcrash, kcoreaddons, ki18n, kwidgetsaddons, kxmlgui
}:

mkDerivation {
  pname = "kcharselect";
  meta = {
    homepage = "https://apps.kde.org/kcharselect/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.schmittlauch ];
    description = "A tool to select special characters from all installed fonts and copy them into the clipboard";
    mainProgram = "kcharselect";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kbookmarks kconfig kconfigwidgets kcoreaddons kcrash ki18n kwidgetsaddons kxmlgui
  ];
  enableParallelBuilding = true;
}
