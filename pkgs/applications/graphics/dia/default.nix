{ stdenv, fetchgit, autoconf, automake, libtool, gtk2, pkgconfig, perl,
perlXMLParser, libxml2, gettext, python, libxml2Python, docbook5, docbook_xsl,
libxslt, intltool, libart_lgpl, withGNOME ? false, libgnomeui,
gtk-mac-integration }:

stdenv.mkDerivation rec {
  name = "dia-${version}";
  version = "0.97.3.20170622";

  src = fetchgit {
    url = https://gitlab.gnome.org/GNOME/dia.git;
    rev = "b86085dfe2b048a2d37d587adf8ceba6fb8bc43c";
    sha256 = "1fyxfrzdcs6blxhkw3bcgkksaf3byrsj4cbyrqgb4869k3ynap96";
  };

  buildInputs =
    [ gtk2 perlXMLParser libxml2 gettext python libxml2Python docbook5
      libxslt docbook_xsl libart_lgpl ]
      ++ stdenv.lib.optional withGNOME libgnomeui
      ++ stdenv.lib.optional stdenv.isDarwin gtk-mac-integration;

  nativeBuildInputs = [ autoconf automake libtool pkgconfig intltool perl ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh # autoreconfHook is not enough
  '';
  configureFlags = stdenv.lib.optionalString withGNOME "--enable-gnome";

  hardeningDisable = [ "format" ];

  # This file should normally require a gtk-update-icon-cache -q /usr/share/icons/hicolor command
  # It have no reasons to exist in a redistribuable package
  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = {
    description = "Gnome Diagram drawing software";
    homepage = http://live.gnome.org/Dia;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
