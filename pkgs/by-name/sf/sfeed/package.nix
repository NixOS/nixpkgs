{
  stdenv,
  lib,
  fetchgit,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfeed";
  version = "2.2";

  src = fetchgit {
    url = "git://git.codemadness.org/sfeed";
    tag = finalAttrs.version;
    hash = "sha256-ULCYZYRTdrsUaL0XJd5Dxa9Cd0Hc6PVNMnnLTGs4pIo=";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "RANLIB:=$(RANLIB)"
    "SFEED_CURSES_LDFLAGS:=-lncurses"
  ]
  # use macOS's strlcat() and strlcpy() instead of vendored ones
  ++ lib.optional stdenv.hostPlatform.isDarwin "COMPATOBJ:=";

  installFlags = [ "PREFIX=$(out)" ];

  # otherwise does not find SIGWINCH
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_DARWIN_C_SOURCE";

  meta = {
    homepage = "https://codemadness.org/sfeed-simple-feed-parser.html";
    description = "RSS and Atom parser (and some format programs)";
    longDescription = ''
      It converts RSS or Atom feeds from XML to a TAB-separated file. There are
      formatting programs included to convert this TAB-separated format to
      various other formats. There are also some programs and scripts included
      to import and export OPML and to fetch, filter, merge and order feed
      items.
    '';
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.all;
  };
})
