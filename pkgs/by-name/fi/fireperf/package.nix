{
  lib,
  stdenv,
  fetchurl,
  intltool,
  asciidoc,
  docbook-xsl-nons,
  libxslt,
  pkg-config,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fireperf";
  version = "0.3.0";

  src = fetchurl {
    url = "https://source.ipfire.org/releases/fireperf/fireperf-${finalAttrs.version}.tar.xz";
    hash = "sha256-TLKDxHPYoH4XkZufv+YMDzeH76wR/inPj0HdgeZce7M=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    intltool
    asciidoc
    docbook-xsl-nons
    libxslt
    pkg-config
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network quality and throughput monitor with a graph";
    homepage = "https://www.ipfire.org/fireperf";
    downloadPage = "https://source.ipfire.org/releases/fireperf/";
    changelog = "https://git.ipfire.org/?p=fireperf.git;a=log";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ VZstless ];
    # darwin cannot find <sys/epoll.h>, which is fireperf's only IO backend.
    platforms = lib.platforms.linux;
  };
})
