{
  lib,
  fetchFromGitLab,
  stdenv,

  flint,
  gmp,
  libmpc,
  mpfr,
  notcurses,
  windows,

  gsl,
  man,
  pkg-config,
  writableTmpDirAsHomeHook,

  unstableGitUpdater,
  writeScript,

  static ? false,
  withGMP ? !static,
  withArb ? !static,
  withNrepl ? if stdenv.hostPlatform.isMinGW then false else true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s7";
  version = "11.7-unstable-2025-11-25";

  src = fetchFromGitLab {
    domain = "cm-gitlab.stanford.edu";
    owner = "bil";
    repo = "s7";
    rev = "eb523a95c050ccabb912dc1e5fad1ba32ea4c9d8";
    hash = "sha256-Gkn+kUiwq3yn7qJwFAiJKl/u/4gGTMuDo7tQEXSY+Lo=";
  };

  buildInputs =
    lib.optional withArb flint
    ++ lib.optionals withGMP [
      gmp
      mpfr
      libmpc
    ]
    ++ lib.optional withNrepl notcurses
    ++ lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  # The following scripts are modified from [Guix's](https://packages.guix.gnu.org/packages/s7/).

  postPatch = ''
    substituteInPlace s7.c \
        --replace-fail libc_s7.so $out/lib/libc_s7.so
  '';
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-I."
      "-O2"
    ]
    ++ lib.optionals withGMP [
      "-DWITH_GMP"
    ]
    ++ lib.optional static "-static"
  );
  env.NIX_LDFLAGS = toString (
    [
      "-lm"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      "-ldl"
      "--export-dynamic"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
      "-lpthread"
      "--export-all-symbols"
    ]
    ++ lib.optional (!static && stdenv.hostPlatform.isMinGW) [ "--out-implib,libs7dll.a" ]
    ++ lib.optional withArb "-lflint"
    ++ lib.optionals withGMP [
      "-lgmp"
      "-lmpfr"
      "-lmpc"
    ]
  );

  buildPhase = ''
    runHook preBuild

    # The older REPL
    $CC s7.c -o s7-repl \
        -DWITH_MAIN \
        -DS7_LOAD_PATH=\"$out/share/s7/scm\"

    $CC s7.c -c -o s7.o

    # Static library (Unix: .a, Windows: .a)
    ${lib.optionalString static ''
      $AR rcs libs7.a s7.o
    ''}

    # Dynamic library (Unix: .so, Windows: .dll)
    ${lib.optionalString (!static && stdenv.hostPlatform.isLinux) ''
      $CC s7.o -o libs7.so \
        -shared -fPIC
    ''}
    ${lib.optionalString (!static && stdenv.hostPlatform.isMinGW) ''
      $CC s7.o -o libs7.dll \
        -shared
    ''}

    ${lib.optionalString withArb ''
      $CC libarb_s7.c s7.o -o libarb_s7.so \
          -shared -fPIC
    ''}

    # The newer REPL powered by Notcurses
    ${lib.optionalString withNrepl ''
      $CC s7.c -o s7-nrepl \
          -DWITH_MAIN \
          -DWITH_NOTCURSES -lnotcurses-core \
          -DS7_LOAD_PATH=\"$out/share/s7/scm\"

      $CC notcurses_s7.c -o libnotcurses_s7.so \
          -Wno-error=implicit-function-declaration \
          -lnotcurses-core \
          -shared -fPIC
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      ./s7-repl libc.scm
    ''}

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

    ${lib.optionalString static ''
      mv -t $dst_lib libs7.a
    ''}
    ${lib.optionalString (!static && stdenv.hostPlatform.isLinux) ''
      mv -t $dst_lib libs7.so
    ''}
    ${lib.optionalString (!static && stdenv.hostPlatform.isMinGW) ''
      mv -t $dst_lib libs7.dll libs7dll.a
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mv -t $dst_bin s7-repl
      mv -t $dst_lib libc_s7.so
    ''}
    ${lib.optionalString stdenv.hostPlatform.isMinGW ''
      mv -t $dst_bin s7-repl.exe
    ''}

    ${lib.optionalString withArb ''
      mv -t $dst_lib libarb_s7.so
    ''}
    ${lib.optionalString withNrepl ''
      mv -t $dst_bin s7-nrepl
      ln -s s7-nrepl $dst_bin/s7
      mv -t $dst_lib libnotcurses_s7.so
    ''}

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
    writableTmpDirAsHomeHook
  ];

  installCheckInputs = [
    gsl
  ];

  /*
    The test suite assumes that "there are two subdirectories of the home directory referred to: cl and test",
    where `cl` is "the s7 source directory" and `test` is "a safe place to write temp files".
  */
  installCheckPhase = ''
    runHook preInstallCheck

    ln -sr . $HOME/cl
    mkdir $HOME/test

    $CC s7.c -c -o s7.o
    $CC ffitest.c s7.o -o ffitest
    mv ffitest $dst_bin

    ${lib.optionalString withArb ''
      substituteInPlace s7test.scm \
          --replace-fail '(system "gcc -fPIC -c libarb_s7.c")' "" \
          --replace-fail '(system "gcc libarb_s7.o -shared -o libarb_s7.so -lflint -larb")' ""
      cp $out/lib/libarb_s7.so .
    ''}

    PATH="$dst_bin:$PATH" \
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
    maintainers = with lib.maintainers; [
      rc-zb
      jinser
    ];
    mainProgram = "s7";
    platforms = lib.platforms.linux ++ lib.platforms.windows;
  };
})
