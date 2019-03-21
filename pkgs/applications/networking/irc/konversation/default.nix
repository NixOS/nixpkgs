{ mkDerivation
, lib
, fetchurl
, fetchpatch
, extra-cmake-modules
, kdoctools
, kbookmarks
, karchive
, kconfig
, kconfigwidgets
, kcoreaddons
, kcrash
, kdbusaddons
, kemoticons
, kglobalaccel
, ki18n
, kiconthemes
, kidletime
, kitemviews
, knotifications
, knotifyconfig
, kwindowsystem
, kio
, kparts
, kwallet
, solid
, sonnet
, phonon
}:

let
  pname = "konversation";
  version = "1.7.5";
in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0h098yhlp36ls6pdvs2r93ig8dv4fys62m0h6wxccprb0qrpbgv0";
  };

  buildInputs = [
    kbookmarks
    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kdoctools
    kemoticons
    kglobalaccel
    ki18n
    kiconthemes
    kidletime
    kitemviews
    knotifications
    knotifyconfig
    kwindowsystem
    kio
    kparts
    kwallet
    solid
    sonnet
    phonon
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  meta = {
    description = "Integrated IRC client for KDE";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://konversation.kde.org;
  };
}
