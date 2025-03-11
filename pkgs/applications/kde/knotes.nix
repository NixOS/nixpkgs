{
  lib,
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdnssd,
  kglobalaccel,
  kiconthemes,
  kitemmodels,
  kitemviews,
  kcmutils,
  knewstuff,
  knotifications,
  knotifyconfig,
  kparts,
  ktextwidgets,
  kwidgetsaddons,
  kwindowsystem,
  grantlee,
  grantleetheme,
  qtx11extras,
  akonadi,
  akonadi-notes,
  akonadi-search,
  kcalutils,
  kontactinterface,
  libkdepim,
  kmime,
  pimcommon,
  kpimtextedit,
  kcalendarcore,
}:

mkDerivation {
  pname = "knotes";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kdnssd
    kglobalaccel
    kiconthemes
    kitemmodels
    kitemviews
    kcmutils
    knewstuff
    knotifications
    knotifyconfig
    kparts
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
    grantlee
    grantleetheme
    qtx11extras
    akonadi
    akonadi-notes
    kcalutils
    kontactinterface
    libkdepim
    kmime
    pimcommon
    kpimtextedit
    akonadi-search
    kcalendarcore
  ];
  meta = with lib; {
    homepage = "https://apps.kde.org/knotes/";
    description = "Popup notes";
    license = licenses.gpl2Plus;
  };
}
