{ stdenv, lib, fetchurl, pkgconfig, cmake,
  extra-cmake-modules, ki18n, gpgme, qgpgme, qtbase, qtsvg,
  plasma-framework, plasma-workspace, kcmutils, kitemmodels, karchive,
  aqbanking, alkimia, kdiagram, kdewebkit, gwenhywfar,
  kinit, makeWrapper, kcoreaddons, kfilemetadata, kio, kdbusaddons,
  kiconthemes
}:

stdenv.mkDerivation rec {
  name = "kmymoney-${version}";
  version = "5.0.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/kmymoney/${version}/src/${name}.tar.xz";
    sha256 = "dd6e8fc22a48ddcb322565c8f385d6aa44d582cfcf6fe2ff3dc11fc0b6bd2ab1";
  };

  sourceRoot = "${name}";

  nativeBuildInputs = [
    pkgconfig cmake extra-cmake-modules
  ];

  propagatedBuildInputs = [
    ki18n gpgme qgpgme kcoreaddons
    qtbase qtsvg plasma-framework kcmutils kitemmodels karchive
    alkimia kdiagram kdewebkit aqbanking gwenhywfar makeWrapper
    kio kdbusaddons qtbase kfilemetadata kiconthemes
  ];

  patchPhase = ''
      find . -name "*.h" -exec sed -i 's@#include <KItemModels@#include <KF5/KItemModels@g' {} \;
  '';

  meta = with stdenv.lib; {
    description = "KDE personal money manager";
    homepage = https://kmymoney.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ exi ];
  };
}
