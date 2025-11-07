{
  lib,
  boost,
  clucene_core_2,
  cmake,
  docbook_xml_dtd_45,
  docbook_xsl_ns,
  fetchFromGitHub,
  gettext,
  libxslt,
  perlPackages,
  pkg-config,
  qt6,
  stdenv,
  sword,
}:

let
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bibletime";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "bibletime";
    repo = "bibletime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kYQjkwfWsEijJ/umOylnfvHgv4u16xr3pkr3ALN4O8c=";
  };

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    gettext
    libxslt
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
