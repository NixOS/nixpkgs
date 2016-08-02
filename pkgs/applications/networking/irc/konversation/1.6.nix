{ kdeDerivation
, lib
, fetchurl
, ecm
, kbookmarks
, karchive
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeWrapper
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
, phonon
}:

let
  unwrapped = let
    pname = "konversation";
    version = "1.6";
  in kdeDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "789fd75644bf54606778971310433dbe2bc01ac0917b34bc4e8cac88e204d5b6";
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
      ecm
      kdoctools
    ];

    meta = {
      description = "Integrated IRC client for KDE";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ fridh ];
      homepage = https://konversation.kde.org;
    };
  };
in kdeWrapper unwrapped {
  targets = [ "bin/konversation" ];
}

