{ lib, stdenv, fetchurl, readline, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "gnu-apl";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/apl/apl-${version}.tar.gz";
    sha256 = "sha256-KRhn8bGTdpOrtXvn2aN2GLA3bj4nCVdIVKe75Suyjrg=";
  };

  buildInputs = [ readline gettext ncurses ];

  env.NIX_CFLAGS_COMPILE = toString ((lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 8
    "-Wno-error=int-in-bool-context"
    "-Wno-error=class-memaccess"
    "-Wno-error=restrict"
    "-Wno-error=format-truncation"
    # Needed with GCC 10
    "-Wno-error=maybe-uninitialized"
    # Needed with GCC 11
    "-Wno-error=misleading-indentation"
    # Needed with GCC 12
    "-Wno-error=nonnull"
    "-Wno-error=stringop-overflow"
    "-Wno-error=use-after-free"
   ]) ++ lib.optional stdenv.cc.isClang "-Wno-error=null-dereference");

  patchPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/LApack.cc --replace "malloc.h" "malloc/malloc.h"
  '';

  postInstall = ''
    cp -r support-files/ $out/share/doc/
    find $out/share/doc/support-files -name 'Makefile*' -delete
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Free interpreter for the APL programming language";
    homepage    = "https://www.gnu.org/software/apl/";
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.kovirobi ];
    platforms   = with platforms; linux ++ darwin;
    mainProgram = "apl";

    longDescription = ''
      GNU APL is a free interpreter for the programming language APL, with an
      (almost) complete implementation of ISO standard 13751 aka.  Programming
      Language APL, Extended.  GNU APL was written and is being maintained by
      Jürgen Sauermann.
    '';
  };
}
