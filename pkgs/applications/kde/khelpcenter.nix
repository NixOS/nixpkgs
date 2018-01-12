{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  grantlee, kcmutils, kconfig, kcoreaddons, kdbusaddons, kdelibs4support, ki18n,
  kinit, khtml, kservice, xapian
}:

mkDerivation {
  name = "khelpcenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcmutils kconfig kcoreaddons kdbusaddons kdelibs4support khtml
    ki18n kinit kservice xapian
  ];
}
