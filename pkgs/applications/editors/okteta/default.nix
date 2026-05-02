{
  lib,
  stdenv,
  fetchurl,
  extra-cmake-modules,
  kdoctools,
  wrapQtAppsHook,
  qtscript,
  kconfig,
  kinit,
  karchive,
  kcrash,
  kcmutils,
  kconfigwidgets,
  knewstuff,
  kparts,
  qca-qt5,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "okteta";
  version = "0.26.26";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${finalAttrs.version}/src/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-M5tQs7UUBvn9N9cqLYsL6AvpDpH4JHWCcPmfrPsLXOw=";
  };

  nativeBuildInputs = [
    qtscript
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  buildInputs = [ shared-mime-info ];

  propagatedBuildInputs = [
    kconfig
    kinit
    kcmutils
    kconfigwidgets
    knewstuff
    kparts
    qca-qt5
    karchive
    kcrash
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    license = lib.licenses.gpl2;
    description = "Hex editor";
    homepage = "https://apps.kde.org/okteta/";
    maintainers = with lib.maintainers; [
      peterhoeg
      bkchr
    ];
    platforms = lib.platforms.linux;
  };
})
