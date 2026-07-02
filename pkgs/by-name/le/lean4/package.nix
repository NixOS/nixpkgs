{
  lib,
  stdenv,
  buildCMakePackage,
  cctools,
  fetchFromGitHub,
  git,
  gmp,
  cadical,
  leangz,
  makeWrapper,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  perl,
  testers,
  nix-update-script,
}:
let
  cadical' = cadical.override { version = "2.1.3"; };
in
buildCMakePackage (finalAttrs: {
  pname = "lean4";
  version = "4.30.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YTsfIppd6km7wOjAxRH5KMPsW++ztFDCJT2up72J86Q=";
  };

  # SRI of cmakeDeps FOD (includes .git from upstream clone; update when GIT_TAG moves).
  # From nixpkgs-review: specified a//wKx… mismatched; got:
  cmakeDepsHash = "sha256-oPEvqS064urqo0s0+EMo3RWE0rewNeSBXn33Xo9/fFU=";

  externalTargets = lib.optionals enableMimalloc [ "mimalloc" ];

  # ExternalProject still needs SOURCE_DIR (git update ignores a pre-seeded tree).
  contentGitRepositories = lib.optionalAttrs enableMimalloc {
    mimalloc = "https://github.com/microsoft/mimalloc";
  };

  cmakeDepsBuildInputs = [
    gmp
    libuv
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.tag}")'

    rm -rf src/lake/examples/git/
  '';

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    leangz
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

  buildInputs = [
    gmp
    libuv
    cadical'
  ];

  postInstall = ''
    wrapProgram $out/bin/lean \
      --prefix PATH : ${cadical'}/bin
  '';

  nativeCheckInputs = [
    git
    perl
  ];

  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"
    "-DINSTALL_CADICAL=OFF"
    "-DUSE_MIMALLOC=${if enableMimalloc then "ON" else "OFF"}"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${finalAttrs.version}";
      };
    };
    updateScript = nix-update-script { };
  };

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
