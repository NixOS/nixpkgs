{ stdenv, fetchurl, automake, autoconf, intltool, pkgconfig, gtk3, vte, wrapGAppsHook
, libxslt, docbook_xml_dtd_412, docbook_xsl, libxml2, findXMLCatalogs
}:

let version = "0.3.2"; in

stdenv.mkDerivation rec {
  name = "lxterminal-${version}";

  src = fetchurl {
    url = "https://github.com/lxde/lxterminal/archive/${version}.tar.gz";
    sha256 = "1iafqmccsm3nnzwp6pb2c04iniqqnscj83bq1rvf58ppzk0bvih3";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  nativeBuildInputs = [
    automake autoconf intltool pkgconfig wrapGAppsHook
    libxslt docbook_xml_dtd_412 docbook_xsl libxml2 findXMLCatalogs
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
