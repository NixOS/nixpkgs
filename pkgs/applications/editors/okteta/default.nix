{ stdenv, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

stdenv.mkDerivation rec {
  name = "okteta-${version}";
  version = "0.26.1";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${name}.tar.xz";
    sha256 = "1bqq3ax47xym3ikwn6xsshs1b5gpfg5djrnkzszqnp127f1fxi54";
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
    maintainers = with maintainers; [ peterhoeg bkchr ];
    platforms = platforms.linux;
  };
}
