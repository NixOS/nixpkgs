{ lib, stdenv, fetchgit, autoconf, automake, libtool, gtk2, pkg-config, perlPackages,
libxml2, gettext, python2, libxml2Python, docbook5, docbook_xsl,
libxslt, intltool, libart_lgpl, withGNOME ? false, libgnomeui,
gtk-mac-integration-gtk2 }:

stdenv.mkDerivation {
  pname = "dia";
  version = "0.97.3.20170622";

  src = fetchgit {
    url = "https://gitlab.gnome.org/GNOME/dia.git";
    rev = "b86085dfe2b048a2d37d587adf8ceba6fb8bc43c";
    sha256 = "1fyxfrzdcs6blxhkw3bcgkksaf3byrsj4cbyrqgb4869k3ynap96";
  };

  patches = [
    ./CVE-2019-19451.patch
  ];

  buildInputs =
    [ gtk2 libxml2 gettext python2 libxml2Python docbook5
      libxslt docbook_xsl libart_lgpl ]
      ++ lib.optional withGNOME libgnomeui
      ++ lib.optional stdenv.isDarwin gtk-mac-integration-gtk2;

  nativeBuildInputs = [ autoconf automake libtool pkg-config intltool ]
    ++ (with perlPackages; [ perl XMLParser ]);

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh # autoreconfHook is not enough
  '';
  configureFlags = lib.optional withGNOME "--enable-gnome";

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Gnome Diagram drawing software";
    homepage = "http://live.gnome.org/Dia";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
