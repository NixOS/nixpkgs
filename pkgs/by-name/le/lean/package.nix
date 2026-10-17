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
  version = "4.34.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JO1pCqWeotC4zjiIQZccEPXfVHnuDQC0DugyuJvIMRs=";
  };

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
    tag = "v3.4.5";
    hash = "sha256-vNVZw2YsDkf0GcdFTNb/fXMQLQYvoc8P425LupPShpo=";
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
