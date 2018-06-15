{ stdenv, fetchFromGitHub, asciidoc, dbus, docbook_xml_dtd_45,
  docbook_xml_xslt, libconfig, libdrm, libxml2, libxslt, libGLU_combined, pcre,
  pkgconfig, libXcomposite, libXdamage, libXext, libXfixes, libXinerama,
  libXrandr, libXrender, xwininfo }:

stdenv.mkDerivation rec {
  name = "compton-git-${version}";
  version = "2018-05-21";

  src = fetchFromGitHub {
    owner  = "yshui";
    repo   = "compton";
    rev    = "9b24550814b7c69065f90039b0a5d0a2281b9f81";
    sha256 = "09nn0q9lgv59chfxljips0n8vnwwxi1yz6hmcsiggsl3zvpabpxl";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xml_xslt
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
    maintainers = [ maintainers.ertes maintainers.twey ];
    platforms = platforms.linux;
  };
}
