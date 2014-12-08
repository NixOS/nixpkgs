{ buildEnv
, stdenv, fetchurl
, gnustep_builder
, gnustep_base, gnustep_back, gnustep_gui
}:
let
  version = "0.6.2";
in
gnustep_builder.mkDerivation rec {
  name = "projectcenter-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/ProjectCenter-${version}.tar.gz";
    sha256 = "0wwlbpqf541apw192jb633d634zkpjhcrrkd1j80y9hihphll465";
  };

#  patches = [ ./fixup-preamble.patch ];
  deps = [ gnustep_base gnustep_back gnustep_gui ];
  
  meta = {
    description = "ProjectCenter is GNUstep's integrated development environment (IDE) and allows a rapid development and easy managment of ProjectCenter running on GNUstep applications, tools and frameworks.";

    homepage = http://www.gnustep.org/experience/ProjectCenter.html;

    license = stdenv.lib.licenses.lgpl2Plus;
  
    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
    broken = true;
  };
}