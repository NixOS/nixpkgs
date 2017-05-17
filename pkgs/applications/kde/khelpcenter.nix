{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  grantlee, kconfig, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils,
  kdelibs4support, khtml, kservice, xapian
}:

mkDerivation {
  name = "khelpcenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ ki18n xapian ];
  propagatedBuildInputs = [
    grantlee kdelibs4support khtml kconfig kcoreaddons kdbusaddons
    kinit kcmutils kservice
  ];
}
