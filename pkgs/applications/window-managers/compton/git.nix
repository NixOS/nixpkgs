{ stdenv, fetchFromGitHub, asciidoc, dbus, docbook_xml_dtd_45,
  docbook_xml_xslt, libconfig, libdrm, libxml2, libxslt, mesa, pcre,
  pkgconfig, libXcomposite, libXdamage, libXext, libXfixes, libXinerama,
  libXrandr, libXrender }:

stdenv.mkDerivation {
  name = "compton-git-2015-09-21";

  src = fetchFromGitHub {
    owner  = "chjj";
    repo   = "compton";
    rev    = "2343e4bbd298b35ea5c190c52abd2b0cb9f79a18";
    sha256 = "1pb0ic47sfd796crwk47cya2ahbxsm6ygi6sh4fwd734kwz37h4z";
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
    mesa
    pcre
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
