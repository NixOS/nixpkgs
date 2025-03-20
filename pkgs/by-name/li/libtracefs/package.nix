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
  valgrind,
  sourceHighlight,
  meson,
  flex,
  bison,
  ninja,
  cunit,
  gitUpdater,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "libtracefs";
  version = "1.8.1";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-libtracefs-${version}.tar.gz";
    hash = "sha256-2UiEgY4mQRLpWah+2rVfPiiUYBSSzRAy5gOv4YELQFQ=";
  };

  patches = [
    (fetchpatch {
      name = "add-missing-documentation-to-meson-build.patch";
      url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/patch/?id=4cbebed79b1fe933367e298ea7ddef694b9f98d0";
      hash = "sha256-tSaR0wpxrm50IyMgMoUCcHBB9r8lQQZZYGru6Znre50=";
    })
  ];

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
    valgrind
    sourceHighlight
    flex
    bison
  ];
  buildInputs = [ libtraceevent ];

  ninjaFlags = [
    "all"
    "docs"
  ];

  doCheck = true;
  checkInputs = [ cunit ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev-prefix = "libtracefs-";
  };

  meta = with lib; {
    description = "Linux kernel trace file system library";
    mainProgram = "sqlhist";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
