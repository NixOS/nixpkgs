# This derivation is based on upstream:
# https://github.com/oxcaml/oxcaml/blob/2fa02927477e84914033bb252723bcd0bb56a5ec/default.nix
{
  lib,
  stdenv,
  clangStdenv,
  fetchFromGitHub,
  autoconf,
  bash,
  dune,
  gfortran,
  linkFarm,
  llvm,
  ocaml-ng,
  parallel,
  pkg-config,
  removeReferencesTo,
  rsync,
  which,
  libtool,
  cctools,
  # Configure flags
  addressSanitizer ? false,
  dev ? false,
  flambdaInvariants ? false,
  framePointers ? addressSanitizer,
  multidomain ? false,
  ocamltest ? true,
  pollInsertion ? false,
  stackChecks ? false,
  warnError ? true,
  syntaxQuotations ? false,
}:

let
  # OxCaml bootstraps itself with a vanilla OCaml 5.x compiler.
  # Note on aarch64: upstream pins 5.4.0 plus an in-tree patch that fixes
  # aarch64 assembly generation in the *boot* compiler. nixpkgs' unmodified 5.4
  # works on x86_64. We'd have to adopt the aarch64 patch before we add aarch64
  # to meta.platforms.
  bootCompiler = ocaml-ng.ocamlPackages_5_4.ocaml;

  # OxCaml's configure requires menhir 20231231 exactly.
  menhirLib = ocaml-ng.ocamlPackages_4_14.menhirLib.override { version = "20231231"; };
  menhirSdk = ocaml-ng.ocamlPackages_4_14.menhirSdk.override { inherit menhirLib; };
  menhir =
    (ocaml-ng.ocamlPackages_4_14.menhir.override { inherit menhirLib menhirSdk; }).overrideAttrs
      {
        patches = [ ];
        buildInputs = [
          menhirLib
          menhirSdk
        ];
        postInstall = ''
          ln -s ${menhirLib}/lib/ocaml/*/site-lib/menhirLib $out/lib/
        '';
      };

  # Some bigarray tests need a Fortran compiler, but putting gfortran directly
  # in nativeBuildInputs shadows `as` and `objcopy` from the stdenv, which the
  # build needs to keep.
  gfortranOnly = linkFarm "gfortran-only" { "bin/gfortran" = lib.getExe gfortran; };

  mkFlag = bool: name: if bool then "--enable-${name}" else "--disable-${name}";

  effectiveStdenv = if addressSanitizer then clangStdenv else stdenv;
in

effectiveStdenv.mkDerivation {
  pname = "oxcaml";
  version = "5.2.0+ox";

  src = fetchFromGitHub {
    owner = "oxcaml";
    repo = "oxcaml";
    # The 5.2.0minus-40 tag at time of writing.
    rev = "2fa02927477e84914033bb252723bcd0bb56a5ec";
    hash = "sha256-W5/JMiZJvelNtnQZ1KvkvgzsdxKls/0BPO4Zw/XRT6I=";
  };

  configureFlags = [
    "--enable-runtime5"
    "--cache-file=/dev/null"
    "--with-objcopy=${llvm}/bin/llvm-objcopy"
    "--enable-assembler-suitable-for-dissector=${llvm}/bin/llvm-mc"
    (mkFlag addressSanitizer "address-sanitizer")
    (mkFlag dev "dev")
    (mkFlag flambdaInvariants "flambda-invariants")
    (mkFlag framePointers "frame-pointers")
    (mkFlag multidomain "multidomain")
    (mkFlag ocamltest "ocamltest")
    (mkFlag pollInsertion "poll-insertion")
    (mkFlag stackChecks "stack-checks")
    (mkFlag warnError "warn-error")
    (mkFlag syntaxQuotations "syntax-quotations")
  ];

  nativeBuildInputs = [
    autoconf
    bootCompiler
    dune
    gfortranOnly
    menhir
    parallel
    pkg-config
    removeReferencesTo
    rsync
    which
  ]
  ++ (if effectiveStdenv.hostPlatform.isDarwin then [ cctools ] else [ libtool ]);

  buildInputs = [
    llvm # llvm-objcopy is used for debug info
  ];

  __structuredAttrs = true;
  strictDeps = true;

  enableParallelBuilding = true;
  dontStrip = true;

  separateDebugInfo = false;
  setOutputFlags = false;

  postPatch = ''
    substituteInPlace Makefile Makefile.ox \
      --replace-fail 'SHELL = /usr/bin/env bash' 'SHELL = ${bash}/bin/bash'

    substituteInPlace \
      testsuite/tests/typing-jkind-bounds/poly-variant-limit/test.ml \
      testsuite/tests/typing-jkind-bounds/poly-variant-limit/test_ikinds.ml \
      --replace-fail '/usr/bin/env bash' '${bash}/bin/bash'

    # Upstream has this file on main branch, empty.
    touch oxcaml/tests/backend/vectorizer/test_register_compatible_vectorized.cmx.dump.expected

    patchShebangs --build .
  '';

  preConfigure = ''
    rm -rf _build _install _runtest

    # autoreconfHook is not usable here: libtoolize and autoheader are
    # incompatible with ocaml-flambda.
    autoconf --force
  '';

  # `make ci` is runtest + runtest-upstream + minimizer. The llvmize and dwarf
  # suites are excluded: they sit behind their own targets and need the
  # ocaml-flambda LLVM forks, which are not packaged.
  checkPhase = lib.optionalString ocamltest ''
    runHook preCheck
    make ci
    runHook postCheck
  '';

  postInstall = ''
    $out/bin/generate_cached_generic_functions.exe $out/lib/ocaml/cached-generic-functions

    # Unused build artifacts.
    rm -f $out/bin/dumpobj.byte
    rm -f $out/bin/extract_externals.byte
    rm -f $out/bin/generate_cached_generic_functions.exe
    rm -f $out/bin/ocamlcp
    rm -f $out/bin/ocamlmklib.byte
    rm -f $out/bin/ocamlmktop.byte
    rm -f $out/bin/ocamlobjinfo.byte
    rm -f $out/bin/ocamlopt.byte
    rm -f $out/bin/ocamlprof
    rm -f $out/lib/ocaml/expunge
  '';

  postFixup = ''
    remove-references-to -t ${dune} $out/lib/ocaml/Makefile.config
  '';

  passthru = {
    # Read by nixpkgs' findlib and the OCaml build-support helpers.
    nativeCompilers = true;
    inherit bootCompiler;
  };

  meta = {
    description = "Performance-focused fork of OCaml, home of Flambda 2";
    homepage = "https://oxcaml.org/";
    # Like OCaml itself: LGPL 2.1 with a linking exception.
    license = lib.licenses.lgpl21;
    mainProgram = "ocaml";
    maintainers = with lib.maintainers; [ dimitrijer ];
    # Upstream CI also covers aarch64-linux and aarch64-darwin, but those need
    # the boot-compiler patch described above and have not been built here yet.
    platforms = [ "x86_64-linux" ];
    broken = framePointers && !effectiveStdenv.hostPlatform.isx86_64;
  };
}
