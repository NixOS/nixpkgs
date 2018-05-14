{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools,
  qtscript, kconfig, kinit, karchive, kcrash,
  kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5,
  shared-mime-info
}:

let
  version = "17.12.3";
in mkDerivation rec {
  name = "okteta";
  src = fetchurl {
    url    = "mirror://kde/stable/applications/${version}/src/${name}-${version}.tar.xz";
    sha256 = "03wsv83l1cay2dpcsksad124wzan7kh8zxdw1h0yicn398kdbck4";
  };
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg bkchr ];
  };
  nativeBuildInputs = [ qtscript extra-cmake-modules kdoctools ];
  buildInputs = [ shared-mime-info ];
  propagatedBuildInputs = [
    kconfig kinit kcmutils kconfigwidgets knewstuff kparts qca-qt5
    karchive kcrash
  ];
}
