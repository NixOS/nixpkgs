{ lib
, stdenv
, fetchurl
, ncurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libedit";
  version = "20230828-3.1";

  src = fetchurl {
    url = "https://thrysoee.dk/editline/libedit-${finalAttrs.version}.tar.gz";
    hash = "sha256-TugYK25WkpDn0fRPD3jayHFrNfZWt2Uo9pnGnJiBTa0=";
  };

  outputs = [ "out" "dev" "man" ];

  patches = [
    ./01-cygwin.patch
  ];

  propagatedBuildInputs = [
    ncurses
  ];

  # GCC automatically include `stdc-predefs.h` while Clang does not do this by
  # default. While Musl is ISO 10646 compliant, it does not define
  # __STDC_ISO_10646__.
  # This definition is in `stdc-predefs.h` -- that's why libedit builds just
  # fine with GCC and Musl.
  # There is a DR to fix this issue with Clang which is not merged yet.
  # https://reviews.llvm.org/D137043
  env.NIX_CFLAGS_COMPILE =
    lib.optionalString (stdenv.targetPlatform.isMusl && stdenv.cc.isClang)
      "-D__STDC_ISO_10646__=201103L";

  postFixup = ''
    find $out/lib -type f | \
      grep '\.\(la\|pc\)''$' | \
      xargs sed -i -e 's,-lncurses[a-z]*,-L${ncurses.out}/lib -lncursesw,g'
  '';

  meta = {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "Port of the NetBSD Editline library (libedit)";
    longDescription = ''
       This is an autotool- and libtoolized port of the NetBSD Editline library
       (libedit). This Berkeley-style licensed command line editor library
       provides generic line editing, history, and tokenization functions,
       similar to those found in GNU Readline.
    '';
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
