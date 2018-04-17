{ stdenv, fetchurl, automake, autoconf, intltool, pkgconfig, gtk3, vte
, libxslt, docbook_xml_dtd_412, docbook_xml_xslt, libxml2, findXMLCatalogs
}:

let version = "0.3.1"; in

stdenv.mkDerivation rec {
  name = "lxterminal-${version}";

  src = fetchurl {
    url = "https://github.com/lxde/lxterminal/archive/${version}.tar.gz";
    sha256 = "e91f15c8a726d5c13227263476583137a2639d4799c021ca0726c9805021b54c";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  nativeBuildInputs = [
    automake autoconf intltool pkgconfig
    libxslt docbook_xml_dtd_412 docbook_xml_xslt libxml2 findXMLCatalogs
  ];

  buildInputs = [ gtk3 vte ];

  patches = [
    ./respect-xml-catalog-files-var.patch
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  doCheck = true;

  meta = {
    description = "The standard terminal emulator of LXDE";
    longDescription = ''
      LXTerminal is the standard terminal emulator of LXDE. The terminal is a
      desktop-independent VTE-based terminal emulator for LXDE without any
      unnecessary dependencies.
    '';
    homepage = https://wiki.lxde.org/en/LXTerminal;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.velovix ];
    platforms = stdenv.lib.platforms.linux;
  };
}
