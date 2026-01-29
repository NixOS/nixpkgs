{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  meson,
  ninja,
  cunit,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtraceevent";
  version = "1.8.7";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${finalAttrs.version}";
    hash = "sha256-9rDgAHK1m369CGKxC+NEkW7fzOJsgKTQtk9GLfVEoLg=";
  };

  postPatch = ''
    chmod +x Documentation/install-docs.sh.in
    patchShebangs --build check-manpages.sh Documentation/install-docs.sh.in
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
  ];

  ninjaFlags = [
    "all"
    "docs"
  ];

  doCheck = true;
  checkInputs = [ cunit ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev-prefix = "libtraceevent-";
  };

  meta = {
    description = "Linux kernel trace event library";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wentasah ];
  };
})
