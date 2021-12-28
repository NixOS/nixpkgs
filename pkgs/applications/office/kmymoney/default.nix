{ lib
, stdenv
, mkDerivation
, fetchurl
, substituteAll
, doxygen
, extra-cmake-modules
, graphviz
, kdoctools
, wrapQtAppsHook

, akonadi, alkimia, aqbanking, gmp, gwenhywfar, kactivities, karchive
, kcmutils, kcontacts, kdewebkit, kdiagram, kholidays, kidentitymanagement
, kitemmodels, libical, libofx, qgpgme

, sqlcipher

# Needed for running tests:
, qtbase, xvfb-run

, python3
}:

let
  python = python3.withPackages (ps: with ps; [ weboob ]);
in mkDerivation rec {
  pname = "kmymoney";
  version = "5.1.2";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${version}/src/${pname}-${version}.tar.xz";
    hash = "sha256-N73E52OihJufc59z44s4nAK94cGxhE7c+n46sdW/ezs=";
  };

  patches = [
    (substituteAll {
      src = ./pythonpath.patch;
      pythonpath = "${python}/${python.sitePackages}";
    })
  ];

  nativeBuildInputs = [
    doxygen extra-cmake-modules graphviz kdoctools python
    wrapQtAppsHook
  ];

  buildInputs = [
    akonadi alkimia aqbanking gmp gwenhywfar kactivities karchive kcmutils
    kcontacts kdewebkit kdiagram kholidays kidentitymanagement kitemmodels
    libical libofx qgpgme
    sqlcipher
  ];

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckInputs = [ xvfb-run ];
  installCheckPhase =
    lib.optionalString doInstallCheck ''
      xvfb-run -s '-screen 0 1024x768x24' make test \
        ARGS="-E '(reports-chart-test)'" # Test fails, so exclude it for now.
    '';

  meta = {
    description = "Personal finance manager for KDE";
    homepage = "https://kmymoney.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
