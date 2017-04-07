{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, akonadi-notes, gpgme, grantlee5, kcodecs, kconfig,
  kconfigwidgets, kcontacts, kdepim-apps-libs, kiconthemes, kidentitymanagement,
  kio, kjobwidgets, kmailtransport, kmime, libgravatar, libkleo, qtwebengine,
  qtwebkit, syntax-highlighting
}:
kdeApp {
  name = "messagelib";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-mime akonadi-notes gpgme grantlee5 kcodecs kconfig
    kconfigwidgets kcontacts kdepim-apps-libs kiconthemes kidentitymanagement
    kio kjobwidgets kmailtransport kmime libgravatar libkleo qtwebengine
    qtwebkit syntax-highlighting
  ];
}
