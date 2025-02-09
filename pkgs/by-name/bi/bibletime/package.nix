{
  lib,
  boost,
  clucene_core_2,
  cmake,
  docbook_xml_dtd_45,
  docbook_xsl_ns,
  fetchFromGitHub,
  perlPackages,
  pkg-config,
  qt5,
  stdenv,
  sword,
}:

let
  inherit (qt5)
    qtbase
    qtsvg
    qttools
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bibletime";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "bibletime";
    repo = "bibletime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4O8F5/EyoJFJBEWOAs9lzN3TKuu/CEdKfPaOF8gNqps=";
  };

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    pkg-config
    wrapQtAppsHook
    perlPackages.Po4a
  ];

  buildInputs = [
    boost
    clucene_core_2
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
    (lib.cmakeBool "BUILD_HOWTO_PDF" false)
    (lib.cmakeBool "BUILD_HANDBOOK_PDF" false)
    (lib.cmakeFeature "BT_DOCBOOK_XSL_HTML_CHUNK_XSL" "${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl")
    (lib.cmakeFeature "BT_DOCBOOK_XSL_PDF_DOCBOOK_XSL" "${docbook_xsl_ns}/share/xml/docbook-xsl-ns/html/chunk.xsl")
  ];

  strictDeps = true;

  meta = {
    homepage = "http://www.bibletime.info/";
    description = "Powerful cross platform Bible study tool";
    license = lib.licenses.gpl2Plus;
    mainProgram = "bibletime";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
