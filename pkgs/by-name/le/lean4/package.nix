{
  lib,
  stdenv,
  cmake,
  cctools,
  fetchFromGitHub,
  gitMinimal,
  runtimeShell,
  which,
  gmp,
  cadical,
  leangz,
  makeWrapper,
  openssl,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  ctestCheckHook,
  coreutils,
  perl,
  python3,
  tzdata,
  versionCheckHook,

  # Official releases go up to `stage2`.  It should typically be enough to build `stage1`, but
  # obscure issues can arise if the checked-in `stage0` is not up-to-date.
  leanStage ? 1,
}:

let
  cadical' = cadical.override { version = "2.1.3"; };
in

assert lib.elem leanStage [
  1
  2
  3
];

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.35.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WjyIRo2BvfnNq13r+YSnTc6VaYupKJIsgfQhFBMa0aU=";
  };

  patches = [
    # Darwin's stdenv uses GNU sed and the GNU coreutils
    ./macos-test-flags-gnu.patch
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

      patchShebangs --build stage0/src/bin/ src/bin/ tests/

      substituteInPlace src/lean.mk.in \
        --replace-fail 'SHELL = /usr/bin/env bash' \
                      'SHELL = ${runtimeShell}'

      substituteInPlace src/lake/Lake/CLI/Check.lean \
        --replace-fail 'cmd := "which"' \
                      'cmd := "${lib.getExe which}"'

      substituteInPlace tests/lake/tests/fake-bwrap.sh \
        --replace-fail 'ENV_BIN=/usr/bin/env' \
                      'ENV_BIN=${coreutils}/bin/env'
    '';

  nativeBuildInputs = [
    cadical'
    cmake
    pkg-config
    makeWrapper
    leangz # Provides leantar
    gitMinimal
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

  # Using a vendored version rather than nixpkgs' version to match the exact version required by
  # Lean.  Apparently, even a slight version change can impact greatly the final performance.
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v3.4.5";
    hash = "sha256-vNVZw2YsDkf0GcdFTNb/fXMQLQYvoc8P425LupPShpo=";
  };

  # Intentionally untyped i.e. no `-DFOO:BOOL=FALSE`. The top-level CMakeLists.txt will not forward
  # the flags to each stage otherwise.
  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_CADICAL=OFF"
    "-DINSTALL_LICENSE=OFF"
    "-DUSE_MIMALLOC=${if enableMimalloc then "ON" else "OFF"}"
    "-DFETCHCONTENT_SOURCE_DIR_MIMALLOC=${finalAttrs.mimalloc-src.outPath}"

    # Better log output with a "dumb" terminal
    "-DLEAN_EXTRA_LAKE_OPTS=--no-ansi"
  ];

  preBuild = ''
    if [ -z "$enableParallelBuilding" ]; then
      export LEAN_NUM_THREADS=1
    else
      export LEAN_NUM_THREADS=$NIX_BUILD_CORES
    fi
  '';

  buildFlags = [
    "all"
    "stage${toString leanStage}"
  ];

  nativeCheckInputs = [
    ctestCheckHook
    perl
    python3
    tzdata
  ];

  ctestFlags = [
    "--test-dir"
    "stage${toString leanStage}"
  ];

  disabledTests = [
    # Assumes we are in a git repo
    "lint.py"

    # Fails without network access
    "elab/async_dns.lean"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails on Darwin
    "elab/async_systems_info.lean"
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  installFlags = [
    "-C"
    "stage${toString leanStage}"
  ];

  postFixup = ''
    # Replace the installed copy of `leantar` with a symlink.
    ln -sf ${leangz}/bin/leantar $out/bin/leantar

    wrapProgram $out/bin/lake \
      --set-default LEAN_CC ${stdenv.cc}/bin/cc \
      --set-default LEAN_AR ${stdenv.cc.bintools.bintools}/bin/ar
  '';

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
      alejo7797
    ];
    mainProgram = "lean";
  };
})
