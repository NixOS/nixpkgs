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
  version = "1.7.4";
in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0y4rj4fcl1wsi3y1fhnzad9nf4llwrnipfm9mfm55kqnx1zmpvqp";
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

  patches = [
    (fetchpatch {
      url = "https://cgit.kde.org/konversation.git/patch/?id=20018b3d0798421c9cb8a9d983e5a5b34bd88e8d";
      sha256 = "0y5m5zimfhc0d1xnkzs05c8ig11lhwdn04fk76vi7966hx8wggnn";
    })
  ];

  meta = {
    description = "Integrated IRC client for KDE";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://konversation.kde.org;
  };
}
