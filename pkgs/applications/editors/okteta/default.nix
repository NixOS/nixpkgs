{ stdenv, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

stdenv.mkDerivation rec {
  name = "okteta-${version}";
  version = "0.25.5";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${name}.tar.xz";
    sha256 = "1680hx4n36msz86gyjsdr5v7nf8rpybvzrvfw8y98l95hfq3l6g9";
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
