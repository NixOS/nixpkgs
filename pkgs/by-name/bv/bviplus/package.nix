{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bviplus";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/bviplus/bviplus/${finalAttrs.version}/bviplus-${finalAttrs.version}.tgz";
    hash = "sha256-LyukklCYy5U3foabc2hB7ZHbJdrDXlyuXkvlGH1zAiM=";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://sourceforge.net/p/bviplus/bugs/7/
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://sourceforge.net/p/bviplus/bugs/7/attachment/bviplus-ncurses-6.2.patch";
      hash = "sha256-3ZC7pPew40quekb5JecPQg2gRFi0DXeMjxQPT5sTerw=";
      # svn patch, rely on prefix added by fetchpatch:
      extraPrefix = "";
    })
  ];

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-int -fgnu89-inline";

  meta = {
    description = "Ncurses based hex editor with a vim-like interface";
    homepage = "https://bviplus.sourceforge.net";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "bviplus";
  };
})
