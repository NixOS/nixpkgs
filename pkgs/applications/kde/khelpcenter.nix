{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  grantlee, kcmutils, kconfig, kcoreaddons, kdbusaddons, ki18n,
  kinit, khtml, kservice, xapian
}:

mkDerivation {
  pname = "khelpcenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcmutils kconfig kcoreaddons kdbusaddons khtml
    ki18n kinit kservice xapian
  ];
}
