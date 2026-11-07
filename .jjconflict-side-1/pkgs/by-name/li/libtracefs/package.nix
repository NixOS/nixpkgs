{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  libtraceevent,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  sourceHighlight,
  meson,
  flex,
  bison,
  ninja,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtracefs";
  version = "1.8.3";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-libtracefs-${finalAttrs.version}.tar.gz";
    hash = "sha256-uN4alsOmj7IFUL2IJSHbgBiztv2Sq0+MktQiRByvhK0=";
  };

  postPatch = ''
    chmod +x samples/extract-example.sh
    patchShebangs --build check-manpages.sh samples/extract-example.sh Documentation/install-docs.sh.in
  '';

  outputs = [
    "out"
    "dev"
    "devman"
    "doc"
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    sourceHighlight
    flex
    bison
  ];
  buildInputs = [ libtraceevent ];

  ninjaFlags = [
    "all"
    "docs"
  ];

  doCheck = false; # needs root

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev-prefix = "libtracefs-";
  };

  meta = {
    description = "Linux kernel trace file system library";
    mainProgram = "sqlhist";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wentasah ];
  };
})
