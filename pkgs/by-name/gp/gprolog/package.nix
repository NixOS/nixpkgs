{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gprolog";
  version = "1.5.0";

  src = fetchurl {
    urls = [
      "mirror://gnu/gprolog/gprolog-${finalAttrs.version}.tar.gz"
      "http://www.gprolog.org/gprolog-${finalAttrs.version}.tar.gz"
      "https://github.com/didoudiaz/gprolog/archive/refs/tags/v${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-ZwZCtDwPqifr1olh77F+vnB2iPkbaAlWbd1gYTlRLAE=";
  };

  __structuredAttrs = true;
  enableParallelBuilding = true;

  hardeningDisable = lib.optional stdenv.hostPlatform.isi686 "pic";

  patchPhase = ''
    sed -i -e "s|/tmp/make.log|$TMPDIR/make.log|g" Pl2Wam/check_boot
  '';

  sourceRoot = "gprolog-${finalAttrs.version}/src";

  configureFlags = [
    "--without-links-dir"
    "--with-install-dir=${placeholder "out"}"
    "--with-examples-dir=${placeholder "out"}/share/gprolog-${finalAttrs.version}/examples"
    "--with-doc-dir=${placeholder "out"}/share/gprolog-${finalAttrs.version}/doc"
    "--htmldir=${placeholder "out"}/share/gprolog-${finalAttrs.version}/doc"
    "--with-c-flags=-std=gnu17"
  ];

  doCheck = true;

  postInstall = ''
    mv -v $out/[A-Z]* $out/gprolog.ico $out/share/gprolog-${finalAttrs.version}
  '';

  meta = {
    homepage = "https://www.gnu.org/software/gprolog/";
    description = "GNU Prolog, a free Prolog compiler with constraint solving over finite domains";
    license = with lib.licenses; [
      lgpl3Plus # and/or
      gpl2Plus
    ];

    longDescription = ''
      GNU Prolog is a free Prolog compiler with constraint solving
      over finite domains developed by Daniel Diaz.

      GNU Prolog accepts Prolog+constraint programs and produces
      native binaries (like gcc does from a C source).  The obtained
      executable is then stand-alone.  The size of this executable can
      be quite small since GNU Prolog can avoid to link the code of
      most unused built-in predicates.  The performances of GNU Prolog
      are very encouraging (comparable to commercial systems).

      Beside the native-code compilation, GNU Prolog offers a
      classical interactive interpreter (top-level) with a debugger.

      The Prolog part conforms to the ISO standard for Prolog with
      many extensions very useful in practice (global variables, OS
      interface, sockets,...).

      GNU Prolog also includes an efficient constraint solver over
      Finite Domains (FD).  This opens contraint logic programming to
      the user combining the power of constraint programming to the
      declarativity of logic programming.
    '';

    platforms = lib.platforms.all;
  };
})
