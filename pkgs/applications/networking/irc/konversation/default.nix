{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, kbookmarks
, karchive
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kemoticons
, kglobalaccel
, ki18n
, kiconthemes
, kidletime
, kitemviews
, knotifications
, knotifyconfig
, kio
, kparts
, kwallet
, solid
, sonnet
, phonon
}:

let
  pname = "konversation";
  version = "1.6.2";
in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1798sslwz7a3h1v524ra33p0j5iqvcg0v1insyvb5qp4kv11slmn";
  };

  buildInputs = [
    kbookmarks
    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
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
