{ stdenv, fetchurl, gnustep_startup }:

let
  version = "1.2.18";
in
stdenv.mkDerivation rec {
  name = "gorm-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "1vpzvmsnynlq5dv6rw9vbk1zzsim6z7b2kprrlm8dknyq0r1sdrq";
  };

  buildInputs = [ gnustep_startup ];
  buildPhase = ''
    . ${gnustep_startup}/System/Library/Makefiles/GNUstep.sh
    make
  '';

  meta = {
    description = "Gorm stands for Graphical Object Relationship Modeller and is an easy-to-use interface designer for GNUstep";

    homepage = http://www.gnustep.org/experience/Gorm.html;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
    broken = true;
  };
}