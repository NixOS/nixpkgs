{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  ncurses,
  gettext,
  intltool,
  liburing,
  asciidoc,
  libxslt,
  autoreconfHook,
  docbook-xsl-ns,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fireperf";
  version = "0.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.ipfire.org/pub/git/fireperf.git";
    tag = finalAttrs.version;
    hash = "sha256-O4fOd+eL6nwh8nx1OiSoI5yUNg5NHsOvt27xArMMywU=";
  };

  nativeBuildInputs = [
    asciidoc
    autoreconfHook
    intltool
    libxslt
    pkg-config
  ];

  buildInputs = [
    gettext
    liburing
    ncurses
  ];

  postConfigure = ''
    substituteInPlace Makefile \
      --replace-fail "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" "${docbook-xsl-ns}/xml/xsl/docbook/manpages/docbook.xsl"
  '';

  meta = {
    description = "Find out what your network can really take - and what is in between";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dagenix ];
    platforms = lib.platforms.linux;
    homepage = "https://www.ipfire.org/fireperf";
    mainProgram = "fireperf";
  };
})
