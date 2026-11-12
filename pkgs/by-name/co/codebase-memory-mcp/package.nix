{
  lib,
  bash,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  stdenv,
  versionCheckHook,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "codebase-memory-mcp";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "DeusData";
    repo = "codebase-memory-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qmLm6jALuPUh6+gSEmWzECWL7AC8HOHAbUHDpYOJlbs=";
  };

  patches = [
    ./remove-install-update.diff
  ];

  postPatch = ''
    substituteInPlace Makefile.cbm \
      --replace-fail "npm ci &&" ""

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # Keep mimalloc available through its direct API, without interposing on libc.
      substituteInPlace Makefile.cbm \
        --replace-fail 'ifneq ($(filter yes,$(IS_MINGW) $(IS_LINUX)),)' 'ifneq ($(filter yes,$(IS_MINGW)),)'
    ''}

    patchShebangs scripts/embed-frontend.sh
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-MKXmiMUofKka1C1jwlm+Mq8X90cTMvipfTC3eX0iv60=";
  };

  npmRoot = "graph-ui";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  buildInputs = [
    bash
    zlib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  env = {
    # Do not let onnxruntime-node fetch execution providers from NuGet.
    ONNXRUNTIME_NODE_INSTALL = "skip";
  };

  enableParallelBuilding = true;

  makefile = "Makefile.cbm";

  # scripts/build.sh verifies CC via `file`, which fails on Nix's compiler wrapper.
  # Call make directly — mirrors upstream flake.nix.
  makeFlags = [
    "cbm-with-ui"
    "CFLAGS_EXTRA='-DCBM_VERSION=\"${finalAttrs.version}\"'"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 build/c/codebase-memory-mcp $out/bin/codebase-memory-mcp

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/DeusData/codebase-memory-mcp";
    description = "High-performance C11 MCP server that indexes codebases into a persistent knowledge graph";
    mainProgram = "codebase-memory-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdifolco ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = stdenv.hostPlatform.isMusl;
  };
})
