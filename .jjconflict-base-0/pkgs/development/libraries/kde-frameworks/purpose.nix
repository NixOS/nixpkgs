{
  mkDerivation, extra-cmake-modules, intltool, qtbase
, accounts-qt, qtdeclarative, kaccounts-integration, kconfig, kcoreaddons, ki18n, kio, kirigami2
, signond
}:

mkDerivation {
  pname = "purpose";
  nativeBuildInputs = [ extra-cmake-modules intltool ];
  buildInputs = [
    qtbase accounts-qt qtdeclarative kaccounts-integration kconfig kcoreaddons
    ki18n kio kirigami2 signond
  ];
}
