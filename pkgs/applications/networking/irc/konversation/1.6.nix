{ stdenv
, lib
, fetchurl
, cmake
, extra-cmake-modules
, kbookmarks
, karchive
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdoctools
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
, makeQtWrapper
, solid
, sonnet
, phonon}:

let
  pn = "konversation";
  v = "1.6";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${name}.tar.xz";
    sha256 = "789fd75644bf54606778971310433dbe2bc01ac0917b34bc4e8cac88e204d5b6";
  };

  buildInputs = [
    cmake
    extra-cmake-modules
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
    makeQtWrapper
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/konversation"
  '';

  meta = {
    description = "Integrated IRC client for KDE";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://konversation.kde.org;
  };
}
