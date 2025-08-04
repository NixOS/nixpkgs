{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  applet-window-buttons,
  karchive,
  kcoreaddons,
  ki18n,
  kio,
  kirigami2,
  mauikit,
  mauikit-documents,
  mauikit-filebrowsing,
  mauikit-texteditor,
  qtmultimedia,
  qtquickcontrols2,
  poppler,
}:

mkDerivation {
  pname = "shelf";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-documents
    mauikit-filebrowsing
    mauikit-texteditor
    qtmultimedia
    qtquickcontrols2
    poppler
  ];

  meta = {
    description = "Document and EBook collection manager";
    mainProgram = "shelf";
    homepage = "https://invent.kde.org/maui/shelf";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
