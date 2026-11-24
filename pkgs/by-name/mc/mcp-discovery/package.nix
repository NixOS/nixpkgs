{
  lib,
  aws-lc,
  bzip2,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xz,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-discovery";
  version = "0.3.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rust-mcp-stack";
    repo = "mcp-discovery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+X3d0SMkwWY99F63OHz3yEFNY17reliHKATONvg+YSc=";
  };

  cargoHash = "sha256-WARswN01YJbDWzbnAiuTJ50yPcdEYkocyfwXDSJgFpM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    bzip2
    xz
    zstd
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for discovering and documenting MCP Server capabilities";
    homepage = "https://github.com/rust-mcp-stack/mcp-discovery";
    changelog = "https://github.com/rust-mcp-stack/mcp-discovery/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mcp-discovery";
  };
})
