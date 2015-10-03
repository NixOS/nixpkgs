{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs, kdebase_workspace }:

let version = "0.11";
in
stdenv.mkDerivation rec {
  name = "rsibreak-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/r/rsibreak/rsibreak_${version}.orig.tar.gz";
    sha256 = "0g27aswh8iz5v67v1wkjny4p100vs2gm0lw0qzfkg6sw1pb4i519";
  };

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  buildInputs = [ kdelibs kdebase_workspace ];

  meta = {
    homepage = http://userbase.kde.org/RSIBreak; # http://www.rsibreak.org/ is down since 2011
    description = "Utility to help prevent repetitive strain injury for KDE 4";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
