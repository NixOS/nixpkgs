{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, akonadi-search, kcmutils, kcodecs,
  kcompletion, kconfigwidgets, kcontacts, kiconthemes, kjobwidgets, kldap
}:
kdeApp {
  name = "libkdepim";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts akonadi-search kcmutils kcodecs
    kcompletion kconfigwidgets kcontacts kiconthemes kjobwidgets kldap   
  ];
}
