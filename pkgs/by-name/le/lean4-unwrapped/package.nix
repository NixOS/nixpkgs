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
  cadical' ? cadical.override { version = "2.1.3"; },
  leangz,
  openssl,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  ctestCheckHook,
  coreutils,
  curl,
  perl,
  python3,
  tzdata,
  versionCheckHook,

  # Official releases go up to `stage2`.  It should typically be enough to build `stage1`, but
  # obscure issues can arise if the checked-in `stage0` is not up-to-date.
  leanStage ? 2,
}:

assert lib.elem leanStage [
  1
  2
  3
];

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4-unwrapped";
  version = "4.36.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9SOI50OuqCknfsJGGpIyzaDRDGADqsJza+5iWbeFmzc=";
  };

  patches = [
    # Darwin's stdenv uses GNU sed and the GNU coreutils
    ./patches/macos-test-flags-gnu.patch

    # Don't export `libcadical.a`'s symbols in Lean's shared libraries
    ./patches/cadical-no-reexport.patch

    # `lake check` tries to bind mount *onto* a symlink!
    ./patches/lake-check-fix-bwrap.patch
  ];

  postPatch = ''
    chmod +x tests/lake/tests/samply/mock-samply.py
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
    leangz # Provides leantar
    gitMinimal
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    cadical'
    gmp
    libuv
    openssl
  ];

  # Using a vendored version rather than nixpkgs' version to match the exact version required by
  # Lean.  Apparently, even a slight version change can impact greatly the final performance.
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v3.4.5";
    hash = "sha256-vNVZw2YsDkf0GcdFTNb/fXMQLQYvoc8P425LupPShpo=";
  };

  preConfigure = ''
    mkdir -p ''${cmakeBuildDir:-build}/mimalloc/src/
    ln -s ${finalAttrs.mimalloc-src} ''${cmakeBuildDir:-build}/mimalloc/src/mimalloc
  '';

  # Intentionally untyped i.e. no `-DFOO:BOOL=FALSE`. The top-level CMakeLists.txt will not forward
  # the flags to each stage otherwise.
  cmakeFlags = [
    "-DCADICAL_INCLUDE_DIR=${lib.getDev cadical'}/include"
    "-DCADICAL_LIB=${lib.getLib cadical'}/lib/libcadical.a"

    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DUSE_MIMALLOC=${if enableMimalloc then "ON" else "OFF"}"

    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"

    # Better log output with a "dumb" terminal
    "-DLEAN_EXTRA_LAKE_OPTS=--no-ansi"

    # Fix `System.Platform.target` not being set
    "-DLEAN_PLATFORM_TARGET=${stdenv.hostPlatform.config}"
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

  # Built separately by upstream CI too
  postBuild = ''
    make -C stage${toString leanStage} ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} \
      SHELL="$SHELL" leanchecker-paranoid
  '';

  nativeCheckInputs = [
    ctestCheckHook
    curl # Needed by tests/lake/tests/samply/test.sh
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
    # Replace the installed copies of `leantar` and `cadical` with symlinks
    ln -sf ${leangz}/bin/leantar $out/bin/leantar
    ln -sf ${cadical'}/bin/cadical $out/bin/cadical
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
