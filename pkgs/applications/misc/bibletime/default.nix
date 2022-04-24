{ lib, mkDerivation, fetchurl, cmake, pkg-config, sword, boost, clucene_core
, qtbase, qttools, qtsvg, perlPackages, docbook_xml_dtd_45
, docbook_xsl_ns }:

mkDerivation rec {
  pname = "bibletime";
  version = "3.0.2";

  src = fetchurl {
    url = "https://github.com/bibletime/bibletime/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-/JNjnU/DGD4YRtrKzX7t6MgNCZYihdgTJc+Jbr9IYJ4=";
  };

  nativeBuildInputs = [ cmake pkg-config docbook_xml_dtd_45 ];
  buildInputs = [
    sword
    boost
    clucene_core
    qtbase
    qttools
    qtsvg
    perlPackages.Po4a
  ];

  preConfigure = ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';

  cmakeFlags = [
    "-DBUILD_HOWTO_PDF=OFF"
    "-DBUILD_HANDBOOK_PDF=OFF"
    "-DBT_DOCBOOK_XSL_HTML_CHUNK_XSL=${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl"
    "-DBT_DOCBOOK_XSL_PDF_DOCBOOK_XSL=${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl"
  ];

  meta = with lib; {
    description = "A Qt4 Bible study tool";
    homepage = "http://www.bibletime.info/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.piotr ];
  };
}
