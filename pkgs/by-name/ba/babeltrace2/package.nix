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
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "efficios";
    repo = "babeltrace";
    rev = "v${version}";
    hash = "sha256-L4YTqPxvWynUBnmAQnlJ2RNbEv9MhBxQOsqbWix8ZwU=";
  };

  patches = [
    # Patches needed for Python 3.12
    (fetchpatch {
      # python: Use standalone 'sysconfig' module
      url = "https://github.com/efficios/babeltrace/commit/452480eb6820df9973d50431a479ca547815ae08.patch";
      hash = "sha256-YgUKHJzdliNUsTY29E0xxcUjqVWn4EvxyTs0B+O+jrI=";
    })
    (fetchpatch {
      # python: replace distutils with setuptools
      url = "https://github.com/efficios/babeltrace/commit/6ec97181a525a3cd64cedbcd0df905ed9e84ba03.patch";
      hash = "sha256-1hlEkPcRUpf2+iEXqHXcCDOaLTg+eaVcahqZlA8m5QY=";
    })
    (fetchpatch {
      # fix: python: monkey patch the proper sysconfig implementation
      url = "https://github.com/efficios/babeltrace/commit/927263e4ea62877af7240cfdb1514ae949dbfc2e.patch";
      hash = "sha256-HNRQ7uw26FUKCQ/my6//OL2xsHdOGlQUq5zIKtg9OGw=";
    })
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs =
    [
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
  ] ++ lib.optional enablePython python;

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
