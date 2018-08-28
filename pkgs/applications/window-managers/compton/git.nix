{ stdenv, fetchFromGitHub, asciidoc, dbus, docbook_xml_dtd_45,
  docbook_xsl, libconfig, libdrm, libxml2, libxslt, libGLU_combined, pcre,
  pkgconfig, libXcomposite, libXdamage, libXext, libXfixes, libXinerama,
  libXrandr, libXrender, xwininfo }:

stdenv.mkDerivation rec {
  name = "compton-git-${version}";
  version = "2018-08-14";

  src = fetchFromGitHub {
    owner  = "yshui";
    repo   = "compton";
    rev    = "cac8094ce12cd40706fb48f9ab35354d9ee7c48f";
    sha256 = "0qif3nx8vszlr06bixasna13pzfaikp86xax9miwnba50517y7v5";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    pkgconfig
  ];

  buildInputs = [
    dbus
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXinerama
    libXrandr
    libXrender
    libconfig
    libdrm
    libxml2
    libxslt
    libGLU_combined
    pcre
  ];

  propagatedBuildInputs = [ xwininfo ];

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description =
      "A fork of XCompMgr, a sample compositing manager for X servers (git version)";
    homepage = https://github.com/yshui/compton/;
    license = licenses.mit;
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    maintainers = with maintainers; [ ertes enzime twey ];
    platforms = platforms.linux;
  };
}
