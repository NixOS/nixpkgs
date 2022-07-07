{ lib, stdenv, fetchFromGitHub, automake, autoconf, intltool, pkg-config, gtk3, vte, wrapGAppsHook
, libxslt, docbook_xml_dtd_412, docbook_xsl, libxml2, findXMLCatalogs, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "lxterminal";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxterminal";
    rev = version;
    sha256 = "sha256-5J21Xvx43Ie01IxB2usyixDl+WZEeFHn2HXZsRS5imo=";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  nativeBuildInputs = [
    automake autoconf intltool pkg-config wrapGAppsHook
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

  passthru.tests.test = nixosTests.terminal-emulators.lxterminal;

  meta = {
    description = "The standard terminal emulator of LXDE";
    longDescription = ''
      LXTerminal is the standard terminal emulator of LXDE. The terminal is a
      desktop-independent VTE-based terminal emulator for LXDE without any
      unnecessary dependencies.
    '';
    homepage = "https://wiki.lxde.org/en/LXTerminal";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.velovix ];
    platforms = lib.platforms.linux;
  };
}
