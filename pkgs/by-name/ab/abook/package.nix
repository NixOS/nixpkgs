{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  ncurses,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abook";
  version = "0.6.2";

  src = fetchgit {
    url = "https://git.code.sf.net/p/abook/git";
    rev = "ver_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-aV57Ob6KN6/eNPrxxmNOy/qfhG687uVy5WY0cd4daCU=";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/abook-gcc15.patch?h=abook";
      hash = "sha256-+73+USELoby8JvuVOWZe6E+xtdhajnLnDkzD/77QoTo=";
    })
  ];

  # error: implicit declaration of function 'isalnum' [-Wimplicit-function-declaration]
  # if (isalnum (*str)) *(p++) = *str;
  postPatch = ''
    substituteInPlace database.c \
      --replace-fail '#include "xmalloc.h"' $'#include "xmalloc.h"\n#include <ctype.h>'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    readline
  ];

  meta = {
    homepage = "http://abook.sourceforge.net/";
    description = "Text-based addressbook program designed to use with mutt mail client";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "abook";
  };
})
