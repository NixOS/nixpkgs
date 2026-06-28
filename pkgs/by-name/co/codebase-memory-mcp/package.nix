{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
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

  nativeBuildInputs = [ gnumake ];

  buildInputs = [ zlib ];

  strictDeps = true;
  __structuredAttrs = true;

  makefile = "Makefile.cbm";

  # scripts/build.sh verifies CC via `file`, which fails on Nix's compiler wrapper.
  # Call make directly — mirrors upstream flake.nix.
  makeFlags = [
    "cbm"
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
