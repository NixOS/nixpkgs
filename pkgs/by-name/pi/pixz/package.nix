{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  asciidoc,
  libxslt,
  libxml2,
  docbook_xml_dtd_45,
  docbook_xsl,
  libarchive,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "pixz";
  version = "1.0.7";

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    libtool
    asciidoc
    libxslt
    libxml2
    docbook_xml_dtd_45
    docbook_xsl
    libarchive
    xz
  ];
  preBuild = ''
    echo "XML_CATALOG_FILES='$XML_CATALOG_FILES'"
  '';
  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = "v${version}";
    sha256 = "163axxs22w7pghr786hda22mnlpvmi50hzhfr9axwyyjl9n41qs2";
  };
  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Parallel compressor/decompressor for xz format";
    license = licenses.bsd2;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    mainProgram = "pixz";
  };
}
