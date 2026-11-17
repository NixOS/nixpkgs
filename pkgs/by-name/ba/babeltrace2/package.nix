{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  glib,
  elfutils,
  bison,
  flex,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  enablePython ? false,
  python ? null,
  pythonPackages ? null,
  swig,
  ensureNewerSourcesForZipFilesHook,
}:

stdenv.mkDerivation rec {
  pname = "babeltrace2";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "efficios";
    repo = "babeltrace";
    rev = "v${version}";
    hash = "sha256-4vqeIwCWEAzsHTdM2S2grF7F4vPqiWTeTEZpxsqf2g8=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    glib
    bison
    flex
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
  ]
  ++ lib.optionals enablePython [
    swig
    pythonPackages.setuptools
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    glib
    elfutils
  ]
  ++ lib.optional enablePython python;

  configureFlags = [
    (lib.enableFeature enablePython "python-bindings")
    (lib.enableFeature enablePython "python-plugins")
    (lib.enableFeature (stdenv.hostPlatform == stdenv.buildPlatform) "debug-info")
  ];

  # For cross-compilation of Python bindings
  makeFlags = [ "CFLAGS=-Wno-error=stringop-truncation -Wno-error=null-dereference" ];

  enableParallelBuilding = true;

  meta = {
    description = "Babeltrace /ˈbæbəltreɪs/ is an open-source trace manipulation toolkit";
    homepage = "https://babeltrace.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wentasah ];
    mainProgram = "babeltrace2";
    platforms = lib.platforms.all;
  };
}
