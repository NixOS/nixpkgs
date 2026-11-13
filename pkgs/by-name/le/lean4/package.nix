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
  cadicalForLean ? cadical.override {
    version = "2.1.3";
    extraConfigureFlags = [ "-fvisibility=hidden" ];
  },
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.36.0-rc2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    rev = "8dba28a9e27426b36f4bccaa72584b2dc2e770dc";
    hash = "sha256-AJHLPcoK3LtYTwI/zNN77YMqPO3Ij6h4a5/oDMjG9VQ=";
  };

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
    cadicalForLean
    cmake
    pkg-config
    leangz # Provides leantar
    gitMinimal
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    cadicalForLean
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

  cmakeFlags = [
    # Flags for top-level `CMakeLists.txt`
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "USE_MIMALLOC" enableMimalloc)
    (lib.cmakeFeature "CADICAL_LIB" "${lib.getLib cadicalForLean}/lib/libcadical.a")
    (lib.cmakeFeature "CADICAL_INCLUDE_DIR" "${lib.getDev cadicalForLean}/include/")

    # Flags for inner `src/CMakeLists.txt`
    (lib.cmakeFeature "STAGE1_LEAN_SPECIAL_VERSION_DESC" "rc2")
    (lib.cmakeBool "STAGE1_USE_GITHASH" false)
    (lib.cmakeBool "STAGE1_INSTALL_LICENSE" false)
    (lib.cmakeBool "STAGE1_INSTALL_CADICAL" false)

    # Produces better log output in sandbox
    (lib.cmakeFeature "STAGE1_LEAN_EXTRA_LAKE_OPTS" "--no-ansi")
  ];

  preBuild = ''
    if [ -z "$enableParallelBuilding" ]; then
      export LEAN_NUM_THREADS=1
    else
      export LEAN_NUM_THREADS=$NIX_BUILD_CORES
    fi
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
    "stage1"
    "--no-tests=error"
  ];

  disabledTests = [
    # Assumes we are in a git repo
    "lint.py"

    # Fails without network access
    "elab/async_dns.lean"
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    # changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.tag}/RELEASES.md";
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
