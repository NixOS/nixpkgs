{ mkDerivation, stdenv, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

mkDerivation rec {
  pname = "okteta";
  version = "0.26.4";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "00qgzm5mqx0j8f0fznhnw76l9pjyw3lxirvy8ssq59nqqjbb08pg";
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

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    description = "A hex editor";
    maintainers = with maintainers; [ peterhoeg bkchr ];
    platforms = platforms.linux;
  };
}
