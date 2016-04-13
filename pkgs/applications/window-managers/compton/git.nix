{ stdenv, fetchFromGitHub, asciidoc, dbus, docbook_xml_dtd_45,
  docbook_xml_xslt, libconfig, libdrm, libxml2, libxslt, mesa, pcre,
  pkgconfig, libXcomposite, libXdamage, libXext, libXfixes, libXinerama,
  libXrandr, libXrender }:

stdenv.mkDerivation {
  name = "compton-git-2015-04-20";

  src = fetchFromGitHub {
    owner  = "chjj";
    repo   = "compton";
    rev    = "b1889c1245e6f47eedfae6063100d5a16f584e2b";
    sha256 = "0brnbidxi7wg08yiwgnijzcyqv5lnkd74xzfymvb0i7pgy465vaf";
  };

  buildInputs = [
    asciidoc
    dbus
    docbook_xml_dtd_45
    docbook_xml_xslt
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
    mesa
    pcre
    pkgconfig
  ];

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description =
      "A fork of XCompMgr, a sample compositing manager for X servers (git version)";
    homepage = https://github.com/chjj/compton/;
    license = licenses.mit;
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions.  It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    maintainers = maintainers.ertes;
    platforms = platforms.linux;
  };
}
