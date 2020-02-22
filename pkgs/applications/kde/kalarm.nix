{
  mkDerivation, lib,
  extra-cmake-modules,

  kauth, kcodecs, kcompletion, kconfig, kconfigwidgets, kdbusaddons, kdoctools,
  kguiaddons, ki18n, kiconthemes, kjobwidgets, kcmutils, kdelibs4support, kio,
  knotifications, kservice, kwidgetsaddons, kwindowsystem, kxmlgui, phonon,

  kimap, akonadi, akonadi-contacts, akonadi-mime, kalarmcal, kcalendarcore, kcalutils,
  kholidays, kidentitymanagement, libkdepim, mailcommon, kmailtransport, kmime,
  pimcommon, kpimtextedit, kdepim-apps-libs, messagelib,

  qtx11extras,

  kdepim-runtime
}:

mkDerivation {
  name = "kalarm";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.rittelle ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kauth kcodecs kcompletion kconfig kconfigwidgets kdbusaddons kdoctools
    kguiaddons ki18n kiconthemes kjobwidgets kcmutils kdelibs4support kio
    knotifications kservice kwidgetsaddons kwindowsystem kxmlgui phonon

    kimap akonadi akonadi-contacts akonadi-mime kalarmcal kcalendarcore kcalutils
    kholidays kidentitymanagement libkdepim mailcommon kmailtransport kmime
    pimcommon kpimtextedit kdepim-apps-libs messagelib

    qtx11extras
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime ];
}
