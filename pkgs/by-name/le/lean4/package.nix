{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cadical,
  cmake,
  leangz,
  makeWrapper,
  pkg-config,
  # darwin-only:
  cctools,

  # buildInputs
  gmp,
  libuv,

  # nativeCheckInputs
  gitMinimal,
  perl,

  # nativeInstallCheckInputs
  versionCheckHook,

  enableMimalloc ? true,
}:
let
  cadical' = cadical.override { version = "2.1.3"; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.31.0";

  __structuredAttrs = true;
  strictDeps = true;

  # Using a vendored version rather than nixpkgs' version to match the exact version required by
  # Lean.  Apparently, even a slight version change can impact greatly the final performance.
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.3";
    hash = "sha256-B0gngv16WFLBtrtG5NqA2m5e95bYVcQraeITcOX9A74=";
  };

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-up4Juc/IyMuggGLMSDgwYEOoMk/K5U8NI0jzeAKqhO0=";
  };

  patches = [
    ./mimalloc.patch
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail \
        'set(GIT_SHA1 "")' \
        'set(GIT_SHA1 "${finalAttrs.src.tag}")'
  ''
  # Remove tests that fails in sandbox.
  # It expects `sourceRoot` to be a git repository.
  + ''
    rm -rf src/lake/examples/git/
  ''
  + lib.optionalString enableMimalloc (
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'MIMALLOC-SRC' '${finalAttrs.mimalloc-src}'
    ''
    + (
      let
        # Single-quoted at the use site so the literal `${LEAN_BINARY_DIR}` reaches
        # substituteInPlace
        pattern = "\${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc";
      in
      ''
        substituteInPlace \
          src/CMakeLists.txt \
          src/runtime/CMakeLists.txt \
          stage0/src/CMakeLists.txt \
          stage0/src/runtime/CMakeLists.txt \
          --replace-fail \
            '${pattern}' \
            '${finalAttrs.mimalloc-src}'
      ''
    )
  );

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cadical'
    cmake
    leangz # Provides leantar
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    cadical'
    gmp
    libuv
  ];

  postInstall = ''
    wrapProgram $out/bin/lean \
      --prefix PATH : ${cadical'}/bin
  '';

  nativeCheckInputs = [
    gitMinimal
    perl
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_GITHASH" false)
    (lib.cmakeBool "INSTALL_LICENSE" false)
    (lib.cmakeBool "INSTALL_CADICAL" false)
    (lib.cmakeBool "USE_MIMALLOC" enableMimalloc)
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
