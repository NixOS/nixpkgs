{
  lib,
  fetchFromGitLab,
  stdenv,

  flint3,
  gmp,
  libmpc,
  mpfr,
  notcurses,

  gsl,
  man,
  pkg-config,

  unstableGitUpdater,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s7";
  version = "11.2-unstable-2024-12-19";

  src = fetchFromGitLab {
    domain = "cm-gitlab.stanford.edu";
    owner = "bil";
    repo = "s7";
    rev = "a5515d455f5aca49d5275a5a35ac88935f3ad401";
    hash = "sha256-Ik3edzpO9hIhJBZHyzL/CsTVKGbDdGVfE9pNrBeSjp8=";
  };

  buildInputs = [
    notcurses
    gmp
    mpfr
    libmpc
    flint3
  ];

  # The following scripts are modified from [Guix's](https://packages.guix.gnu.org/packages/s7/).

  postPatch = ''
    substituteInPlace s7.c \
        --replace-fail libc_s7.so $out/lib/libc_s7.so
  '';

  buildPhase = ''
    runHook preBuild

    # The older REPL
    cc s7.c -o s7-repl \
        -O2 -I. \
        -Wl,-export-dynamic \
        -lm -ldl \
        -DWITH_MAIN \
        -DS7_LOAD_PATH=\"$out/share/s7/scm\"

    # The newer REPL powered by Notcurses
    cc s7.c -o s7-nrepl \
        -O2 -I. \
        -Wl,-export-dynamic \
        -lm -ldl \
        -DWITH_MAIN \
        -DWITH_NOTCURSES -lnotcurses-core \
        -DS7_LOAD_PATH=\"$out/share/s7/scm\"

    cc libarb_s7.c -o libarb_s7.so \
        -O2 -I. \
        -shared \
        -lflint -lmpc \
        -fPIC

    cc notcurses_s7.c -o libnotcurses_s7.so \
        -O2 -I. \
        -shared \
        -lnotcurses-core \
        -fPIC

    cc s7.c -c -o s7.o \
        -O2 -I. \
        -ldl -lm

    ./s7-repl libc.scm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dst_bin=$out/bin
    dst_lib=$out/lib
    dst_inc=$out/include
    dst_share=$out/share/s7
    dst_scm=$out/share/s7/scm
    dst_doc=$out/share/doc/s7
    mkdir -p $dst_bin $dst_lib $dst_inc $dst_share $dst_scm $dst_doc

    mv -t $dst_bin s7-repl s7-nrepl
    ln -s s7-nrepl $dst_bin/s7
    mv -t $dst_lib libarb_s7.so libnotcurses_s7.so libc_s7.so
    cp -pr -t $dst_share s7.c
    cp -pr -t $dst_inc s7.h
    cp -pr -t $dst_scm *.scm
    cp -pr -t $dst_doc s7.html

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    man
    pkg-config
  ];

  installCheckInputs = [
    gsl
  ];

  /*
    XXX: The upstream assumes that `$HOME` is `/home/$USER`, and the source files
    lie in `$HOME/cl` . The script presented here uses a fake `$USER` and a
    symbolic linked `$HOME/cl` , which make the test suite work but do not meet
    the conditions completely.
  */
  installCheckPhase = ''
    runHook preInstallCheck

    cc ffitest.c s7.o -o ffitest \
        -I. \
        -Wl,-export-dynamic \
        -ldl -lm
    mv ffitest $dst_bin
    mkdir -p nix-build/home
    ln -sr . nix-build/home/cl

    USER=nix-s7-builder PATH="$dst_bin:$PATH" HOME=$PWD/nix-build/home \
        s7-repl s7test.scm

    rm $dst_bin/ffitest

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater rec {
    branch = "master";
    tagConverter = writeScript "update-s7-version-number" ''
      #! /usr/bin/env nix-shell
      #! nix-shell -p curl -i bash
      set -eu -o pipefail
      read tag # should be "0" if the upstream sticks to tagging nothing.
      curl -sS https://cm-gitlab.stanford.edu/bil/s7/-/raw/${branch}/s7.h \
          | grep '#define S7_VERSION' \
          | awk -F \" '{print $2}'
    '';
  };

  meta = {
    description = "Scheme interpreter intended as an extension language for other applications";
    longDescription = ''
      s7 is a Scheme interpreter intended as an extension language for other
      applications.

      Although it is a descendant of tinyScheme, s7 is closest as a Scheme
      dialect to Guile 1.8. It is expected to be compatible with r5rs and r7rs.
      It has continuations, ratios, complex numbers, macros, keywords,
      hash-tables, multiprecision arithmetic, generalized `set!`, unicode, and so
      on. It does not have `syntax-rules` or any of its friends, and it thinks
      there is no such thing as an inexact integer.

      s7 is an extension language of Snd and sndlib, Rick Taube's Common Music
      (commonmusic at sourceforge), Kjetil Matheussen's Radium music editor, and
      Iain Duncan's Scheme for Max (or Pd).
    '';
    homepage = "https://ccrma.stanford.edu/software/s7/";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "s7";
    platforms = lib.platforms.linux;
  };
})
