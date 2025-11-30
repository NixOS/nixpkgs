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

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.8.6";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
    hash = "sha256-k084Sl0Uv+/mQM+Voktz3jjcKmXSi7n2VWpZLRcKSrY=";
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

  meta = with lib; {
    description = "Linux kernel trace event library";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
