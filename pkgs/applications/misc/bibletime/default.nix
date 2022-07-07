{ lib
, stdenv
, fetchFromGitHub
, cmake
, docbook_xml_dtd_45
, pkg-config
, wrapQtAppsHook
, boost
, clucene_core_2
, docbook_xsl_ns
, perlPackages
, qtbase
, qtsvg
, qttools
, sword
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bibletime";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "bibletime";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-4O8F5/EyoJFJBEWOAs9lzN3TKuu/CEdKfPaOF8gNqps=";
  };

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    clucene_core_2
    perlPackages.Po4a
    qtbase
    qtsvg
    qttools
    sword
  ];

  preConfigure = ''
    export CLUCENE_HOME=${clucene_core_2};
    export SWORD_HOME=${sword};
  '';

  cmakeFlags = [
    "-DBUILD_HOWTO_PDF=OFF"
    "-DBUILD_HANDBOOK_PDF=OFF"
    "-DBT_DOCBOOK_XSL_HTML_CHUNK_XSL=${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl"
    "-DBT_DOCBOOK_XSL_PDF_DOCBOOK_XSL=${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl"
  ];

  meta = with lib; {
    homepage = "http://www.bibletime.info/";
    description = "A powerful cross platform Bible study tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
})
