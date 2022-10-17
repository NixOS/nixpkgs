{ mkDerivation, lib, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

mkDerivation rec {
  pname = "okteta";
  version = "0.26.9";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-FoVMTU6Ug4IZrjEVpCujhf2lyH3GyYZayQ03dPjQX/s=";
  };

  nativeBuildInputs = [ qtscript extra-cmake-modules kdoctools ];
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

  outputs = [ "out" "dev" ];

  meta = with lib; {
    license = licenses.gpl2;
    description = "A hex editor";
    maintainers = with maintainers; [ peterhoeg bkchr ];
    platforms = platforms.linux;
  };
}
