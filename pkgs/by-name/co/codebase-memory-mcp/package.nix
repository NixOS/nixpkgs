{
  lib,
  bash,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  stdenv,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "codebase-memory-mcp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "DeusData";
    repo = "codebase-memory-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H0l8H2JhPT1Rs0p+CJC1a1qYtnZNgLGe6n7PmM+WvE4=";
  };

  patches = [
    ./remove-install-update.diff
  ];

  postPatch = ''
    substituteInPlace Makefile.cbm \
      --replace-fail "npm ci &&" ""

    substituteInPlace scripts/embed-frontend.sh \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-feoZNsZfrPgoLdjlnnh3w3vTxR6AwPdUkPubaR93TAk=";
  };

  npmRoot = "graph-ui";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    bash
    zlib
  ];

  strictDeps = true;
  __structuredAttrs = true;

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
  };
})
