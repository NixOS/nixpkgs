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
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "DeusData";
    repo = "codebase-memory-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lPuayLN6W31zQ45UTQehP+tmoo/UrQJuRsJzi1wZ9Tg=";
  };

  patches = [
    ./remove-install-update.diff
  ];

  postPatch = ''
    substituteInPlace Makefile.cbm \
      --replace-fail "npm ci &&" ""

    patchShebangs scripts/embed-frontend.sh
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-cDwGJi8M/t7eTHVKu6TzW7L9OUAQgB+0c+fiTgPn7cE=";
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
