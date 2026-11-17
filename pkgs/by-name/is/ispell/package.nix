{
  lib,
  stdenv,
  fetchurl,
  bison,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ispell";
  version = "3.4.06";

  src = fetchurl {
    url = "https://www.cs.hmc.edu/~geoff/tars/ispell-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-F8kWM9TIB1rMUDFjoWRj/FSrHHRTKArTnNPbdceD66Y=";
  };

  buildInputs = [
    bison
    ncurses
  ];

  postPatch = ''
    cat >> local.h <<EOF
    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "#define USG"}
    #define TERMLIB "-lncurses"
    #define LANGUAGES "{american,MASTERDICTS=american.med,HASHFILES=americanmed.hash}"
    #define MASTERHASH "americanmed.hash"
    #define BINDIR "$out/bin"
    #define LIBDIR "$out/lib"
    #define ELISPDIR "{$out}/share/emacs/site-lisp"
    #define TEXINFODIR "$out/share/info"
    #define MAN1DIR "$out/share/man/man1"
    #define MAN4DIR "$out/share/man/man4"
    #define MAN45DIR "$out/share/man/man5"
    #define MINIMENU
    #define HAS_RENAME
    EOF
  '';

  env.NIX_CFLAGS_COMPILE = "-std=gnu17"; # Doesn't compile with C23

  meta = {
    description = "Interactive spell-checking program for Unix";
    homepage = "https://www.cs.hmc.edu/~geoff/ispell.html";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
  };
})
