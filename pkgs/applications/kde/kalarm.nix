{
  mkDerivation, lib,
  extra-cmake-modules,

  kauth, kcodecs, kcompletion, kconfig, kconfigwidgets, kdbusaddons, kdoctools,
  kguiaddons, ki18n, kiconthemes, kidletime, kjobwidgets, kcmutils,
  kio, knotifications, knotifyconfig, kservice, kwidgetsaddons,
  kwindowsystem, kxmlgui, phonon,

  kimap, akonadi, akonadi-contacts, akonadi-mime, kalarmcal, kcalendarcore, kcalutils,
  kholidays, kidentitymanagement, libkdepim, mailcommon, kmailtransport, kmime,
  pimcommon, kpimtextedit, messagelib,

  qtx11extras,

  kdepim-runtime
}:

mkDerivation {
  pname = "kalarm";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.rittelle ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kauth kcodecs kcompletion kconfig kconfigwidgets kdbusaddons kdoctools
    kguiaddons ki18n kiconthemes kidletime kjobwidgets kcmutils
    kio knotifications knotifyconfig kservice kwidgetsaddons kwindowsystem
    kxmlgui phonon

    kimap akonadi akonadi-contacts akonadi-mime kalarmcal kcalendarcore
    kcalutils kholidays kidentitymanagement libkdepim mailcommon kmailtransport
    kmime pimcommon kpimtextedit messagelib

    qtx11extras
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime ];
}
