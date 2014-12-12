{ gnustep_back, gnustep_base, gnustep_gui, gnustep_make
, fetchurl
, sqlite
, stdenv
, system_preferences
}:
let
  version = "0.9.2";
in
stdenv.mkDerivation {
  name = "gworkspace-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${version}.tar.gz";
    sha256 = "1yzlka2dl1gb353wf9kw6l26sdihdhgwvdfg5waqwdfl7ycfyfaj";
  };
  # additional dependencies:
  # - PDFKit framework from http://gap.nongnu.org/
  GNUSTEP_MAKEFILES = "${gnustep_make}/share/GNUstep/Makefiles";
  buildInputs = [ gnustep_back gnustep_base gnustep_make gnustep_gui sqlite system_preferences ];
  propagatedBuildInputs = [ gnustep_back gnustep_base gnustep_gui sqlite system_preferences ];
  configureFlags = [ "--enable-gwmetadata" "--with-inotify" ];
  meta = {
    description = "GWorkspace is a workspace manager for GNUstep";

    homepage = http://www.gnustep.org/experience/GWorkspace.html;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.linux;
  };
}
