{ stdenv, lib, fetchFromGitHub, pkgconfig, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper
, dbus, libconfig, libdrm, mesa_noglu, pcre, libX11, libXcomposite, libXdamage
, libXinerama, libXrandr, libXrender, libXext, xwininfo }:

stdenv.mkDerivation rec {
  name = "compton-0.1_beta2.5";

  src = fetchFromGitHub {
    owner = "chjj";
    repo = "compton";
    rev = "b7f43ee67a1d2d08239a2eb67b7f50fe51a592a8";
    sha256 = "1p7ayzvm3c63q42na5frznq3rlr1lby2pdgbvzm1zl07wagqss18";
  };

  buildInputs = [
    libX11
    libXcomposite
    libXdamage
    libXrender
    libXrandr
    libXext
    libXinerama
    libdrm
    pcre
    libconfig
    dbus
    mesa_noglu
  ];

  nativeBuildInputs = [
    pkgconfig
    asciidoc
    libxml2
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
    makeWrapper
  ];
  
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/compton-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/chjj/compton/;
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
