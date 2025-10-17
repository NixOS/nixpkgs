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

stdenv.mkDerivation rec {
  pname = "libtracefs";
  version = "1.8.2";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-libtracefs-${version}.tar.gz";
    hash = "sha256-rpZUa34HMnDMSsGGwtOriEEHDfnW8emRSHZxzRkY3c4=";
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

  meta = with lib; {
    description = "Linux kernel trace file system library";
    mainProgram = "sqlhist";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
