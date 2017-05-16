{
  mkDerivation,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  grantlee, kconfig, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils,
  kdelibs4support, khtml, kservice, xapian
}:

mkDerivation {
  name = "khelpcenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  buildInputs = [
    grantlee kdelibs4support khtml ki18n kconfig kcoreaddons kdbusaddons
    kinit kcmutils kservice xapian
  ];
}
