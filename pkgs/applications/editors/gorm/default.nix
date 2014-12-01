{ buildEnv
, stdenv, fetchurl, gnustep_base, gnustep_make, gnustep_back, gnustep_gui
}:
let
  version = "1.2.18";
in
stdenv.mkDerivation rec {
  name = "gorm-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "1vpzvmsnynlq5dv6rw9vbk1zzsim6z7b2kprrlm8dknyq0r1sdrq";
  };
  GNUSTEP_env = buildEnv {
    name = "gnustep-gorm-env";
    paths = [ gnustep_make gnustep_back gnustep_base gnustep_gui ];
    pathsToLink = [ "/bin" "/sbin" "/include" "/lib" "/share" ];
  };
  GNUSTEP_MAKEFILES = "${GNUSTEP_env}/share/GNUstep/Makefiles";
  GNUSTEP_INSTALLATION_DOMAIN = "SYSTEM";
  ADDITIONAL_CPPFLAGS = "-DGNUSTEP";
  
  buildInputs = [ gnustep_base gnustep_back gnustep_make gnustep_gui ];
  dontBuild = true;
  installPhase = ''
    export ADDITIONAL_INCLUDE_DIRS=${GNUSTEP_env}/include
    make \
      GNUSTEP_SYSTEM_APPS=$GNUSTEP_env/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_ADMIN_APPS=$GNUSTEP_env/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_WEB_APPS=$GNUSTEP_env/lib/GNUstep/WebApplications \
      GNUSTEP_SYSTEM_TOOLS=$GNUSTEP_env/bin \
      GNUSTEP_SYSTEM_ADMIN_TOOLS=$GNUSTEP_env/sbin \
      GNUSTEP_SYSTEM_LIBRARY=$GNUSTEP_env/lib/GNUstep \
      GNUSTEP_SYSTEM_HEADERS=$GNUSTEP_env/include \
      GNUSTEP_SYSTEM_LIBRARIES=$GNUSTEP_env/lib \
      GNUSTEP_SYSTEM_DOC=$GNUSTEP_env/share/GNUstep/Documentation \
      GNUSTEP_SYSTEM_DOC_MAN=$GNUSTEP_env/share/man \
      GNUSTEP_SYSTEM_DOC_INFO=$GNUSTEP_env/share/info \
      GNUSTEP_SYSTEM_LIBRARIES=$GNUSTEP_env/lib \
      messages=yes
    make install \
      GNUSTEP_INSTALLATION_DOMAIN=SYSTEM \
      GNUSTEP_SYSTEM_APPS=$out/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_ADMIN_APPS=$out/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_WEB_APPS=$out/lib/GNUstep/WebApplications \
      GNUSTEP_SYSTEM_TOOLS=$out/bin \
      GNUSTEP_SYSTEM_ADMIN_TOOLS=$out/sbin \
      GNUSTEP_SYSTEM_LIBRARY=$out/lib/GNUstep \
      GNUSTEP_SYSTEM_HEADERS=$out/include \
      GNUSTEP_SYSTEM_LIBRARIES=$out/lib \
      GNUSTEP_SYSTEM_DOC=$out/share/GNUstep/Documentation \
      GNUSTEP_SYSTEM_DOC_MAN=$out/share/man \
      GNUSTEP_SYSTEM_DOC_INFO=$out/share/info \
      GNUSTEP_SYSTEM_LIBRARIES=$out/lib \
      GNUSTEP_HEADERS=$out/include \
      DESTDIR_GNUSTEP_MAKEFILES=$out/share/GNUstep/Makefiles
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