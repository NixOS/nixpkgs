{ stdenv, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

stdenv.mkDerivation rec {
  name = "okteta-${version}";
  version = "17.12.3";

  src = fetchurl {
    url = "mirror://kde/stable/applications/${version}/src/${name}.tar.xz";
    sha256 = "03wsv83l1cay2dpcsksad124wzan7kh8zxdw1h0yicn398kdbck4";
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
