{
  mkDerivation, lib,
  extra-cmake-modules,

  kauth, kcodecs, kcompletion, kconfig, kconfigwidgets, kdbusaddons, kdoctools,
  kguiaddons, ki18n, kiconthemes, kidletime, kjobwidgets, kcmutils,
  kio, knotifications, knotifyconfig, kservice, kwidgetsaddons,
  kwindowsystem, kxmlgui, phonon,

  kimap, akonadi, akonadi-contacts, akonadi-mime, kcalendarcore, kcalutils,
  kholidays, kidentitymanagement, libkdepim, mailcommon, kmailtransport, kmime,
  pimcommon, kpimtextedit, messagelib,

  qtx11extras,

  kdepim-runtime
}:

mkDerivation {
  pname = "kalarm";
  meta = {
    homepage = "https://apps.kde.org/kalarm/";
    description = "Personal alarm scheduler";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kauth kcodecs kcompletion kconfig kconfigwidgets kdbusaddons kdoctools
    kguiaddons ki18n kiconthemes kidletime kjobwidgets kcmutils
    kio knotifications knotifyconfig kservice kwidgetsaddons kwindowsystem
    kxmlgui phonon

    kimap akonadi akonadi-contacts akonadi-mime kcalendarcore
    kcalutils kholidays kidentitymanagement libkdepim mailcommon kmailtransport
    kmime pimcommon kpimtextedit messagelib

    qtx11extras
  ];
  propagatedUserEnvPkgs = [ kdepim-runtime ];
}
