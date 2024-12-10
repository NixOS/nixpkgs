{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  intltool,
  pkg-config,
  gtk3,
  vte,
  wrapGAppsHook3,
  libxslt,
  docbook_xml_dtd_412,
  docbook_xsl,
  libxml2,
  findXMLCatalogs,
  nixosTests,
  pcre2,
}:

stdenv.mkDerivation rec {
  pname = "lxterminal";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxterminal";
    rev = version;
    sha256 = "sha256-bCF/V6yFe4vKqVMOtNlwYyw/ickj1LFuFn4IyypwIg0=";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  nativeBuildInputs = [
    automake
    autoconf
    intltool
    pkg-config
    wrapGAppsHook3
    libxslt
    docbook_xml_dtd_412
    docbook_xsl
    libxml2
    findXMLCatalogs
  ];

  buildInputs = [
    gtk3
    vte
    pcre2
  ];

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
    maintainers = [ lib.maintainers.pbsds ];
    platforms = lib.platforms.linux;
    mainProgram = "lxterminal";
  };
}
