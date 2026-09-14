{
  lib,
  stdenv,
  cmake,
  cctools,
  fetchFromGitHub,
  fetchpatch,
  gitMinimal,
  gmp,
  cadical,
  leangz,
  makeWrapper,
  openssl,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  perl,
  versionCheckHook,
}:
let
  cadical' = cadical.override { version = "2.1.3"; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.33.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-avTsPLjouuxejTb1kVqbNbhI9CKZuqhGINAy3TaRNcE=";
  };

  patches = [
    # `lean_alloc_small_object` handles sizes up to 4096, but passes them to `mi_malloc_small`,
    # which is only valid up to `MI_SMALL_SIZE_MAX` (1024), corrupting the heap and making `lean`
    # segfault at random (e.g. while building mathlib):
    # https://github.com/leanprover/lean4/issues/14148
    # Fixed upstream in https://github.com/leanprover/lean4/pull/7786, after the 4.33.0 cut.
    (fetchpatch {
      name = "mi_malloc_small-size-overflow.patch";
      url = "https://github.com/leanprover/lean4/commit/171f24d1c7ca8a24ce8a7b305330c33ead7a08df.patch";
      excludes = [ "CMakeLists.txt" ];
      hash = "sha256-KcXtyogTUE6ri+Scdxkw1Zv/XnWZcMGutUpwCvR1EmM=";
    })

    # `ST.Ref.swap` racing against `ST.Ref.get` decrements the wrong object, freeing it while it is
    # still referenced. Same symptom as above, but only under heavy parallelism:
    # https://github.com/leanprover/lean4/issues/14584
    (fetchpatch {
      name = "st-ref-swap-cas.patch";
      url = "https://github.com/leanprover/lean4/commit/8f0ceabca35e829d3be972645b6b29d4ddfb4ee8.patch";
      hash = "sha256-P8o1IV4x8v3DzNl5SX/XFbdlsdb5YiI5YTH2UeWCutk=";
    })
  ]
  # The prebuilt bootstrap compiler in `stage0` carries its own copy of the runtime, and hits both
  # bugs above while building stage1, so it needs them too.
  ++ [
    (fetchpatch {
      name = "mi_malloc_small-size-overflow-stage0.patch";
      url = "https://github.com/leanprover/lean4/commit/171f24d1c7ca8a24ce8a7b305330c33ead7a08df.patch";
      relative = "src";
      extraPrefix = "stage0/src/";
      hash = "sha256-/jxBVn6i59aDCvJWDqzu3OHxcOkDIka/FPhzvRGY/IU=";
    })
    (fetchpatch {
      name = "st-ref-swap-cas-stage0.patch";
      url = "https://github.com/leanprover/lean4/commit/8f0ceabca35e829d3be972645b6b29d4ddfb4ee8.patch";
      relative = "src";
      extraPrefix = "stage0/src/";
      hash = "sha256-oivqD35FwPokjDt7tZ3Id8z8sEGYA49CzEGcwb9fAJ0=";
    })
  ];

  postPatch =
    let
      pattern = "\${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc";
    in
    ''
      substituteInPlace \
        src/CMakeLists.txt \
        src/runtime/CMakeLists.txt \
        stage0/src/CMakeLists.txt \
        stage0/src/runtime/CMakeLists.txt \
        --replace-fail '${pattern}' '${finalAttrs.mimalloc-src}'
    ''
    # Remove tests that fails in sandbox.
    # It expects `sourceRoot` to be a git repository.
    + ''
      rm -rf src/lake/examples/git/
    '';

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cadical'
    cmake
    pkg-config
    makeWrapper
    leangz # Provides leantar
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    gmp
    libuv
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/lean \
      --prefix PATH : ${cadical'}/bin
  '';

  nativeCheckInputs = [
    gitMinimal
    perl
  ];

  # Using a vendored version rather than nixpkgs' version to match the exact version required by
  # Lean.  Apparently, even a slight version change can impact greatly the final performance.
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.3";
    hash = "sha256-B0gngv16WFLBtrtG5NqA2m5e95bYVcQraeITcOX9A74=";
  };

  cmakeFlags = [
    (lib.cmakeBool "USE_GITHASH" false)
    (lib.cmakeBool "INSTALL_LICENSE" false)
    (lib.cmakeBool "INSTALL_CADICAL" false)
    (lib.cmakeBool "USE_MIMALLOC" enableMimalloc)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MIMALLOC" finalAttrs.mimalloc-src.outPath)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      danielbritten
      jthulhu
      nadja-y
      niklashh
    ];
    mainProgram = "lean";
  };
})
