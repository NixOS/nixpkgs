{ stdenv, fetchFromGitHub, asciidoc, dbus, docbook_xml_dtd_45,
  docbook_xml_xslt, libconfig, libdrm, libxml2, libxslt, mesa, pcre,
  pkgconfig, libXcomposite, libXdamage, libXext, libXfixes, libXinerama,
  libXrandr, libXrender, xwininfo }:

stdenv.mkDerivation {
  name = "compton-git-2016-08-10";

  src = fetchFromGitHub {
    owner  = "chjj";
    repo   = "compton";
    rev    = "f1cd308cde0f1e1f21ec2ac8f16a3c873fa22d3a";
    sha256 = "1ky438d1rsg4ylkcp60m82r0jck8rks3gfa869rc63k37p2nfn8p";
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

  propagatedBuildInputs = [ xwininfo ];

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description =
      "A fork of XCompMgr, a sample compositing manager for X servers (git version)";
    homepage = https://github.com/chjj/compton/;
    license = licenses.mit;
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    maintainers = maintainers.ertes;
    platforms = platforms.linux;
  };
}
