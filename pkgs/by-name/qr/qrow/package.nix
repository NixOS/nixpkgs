{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qrow";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "denisotree";
    repo = "qrow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q8VubcGzJjPZpGPoIc8kCiDrPij0XHeOXmNzhJC3S1Y=";
  };

  cargoHash = "sha256-Ej0LMsCCRuQ4VRiWjffS20XvvSbcS/YGF3sNjzm1zqQ=";

  __structuredAttrs = true;

  # qrw is a separate [[bin]] target whose source is byte-identical to
  # `fn main() { qrow::run() }`, so building it yields a second full copy of a
  # ~120 MB binary. Build one and symlink the alias; the program reads argv[0] only
  # for the name in its usage line. Do not restrict cargoTestFlags the same way:
  # tests/mcp_tests.rs needs CARGO_BIN_EXE_qrow and tests/terminal_tests.rs
  # CARGO_BIN_EXE_qrw.
  cargoBuildFlags = [
    "--bin"
    "qrow"
  ];

  # checkPhase runs before installPhase and may leave qrw in target/release for
  # installPhase to pick up, hence `ln -sf` rather than `ln -s`.
  postInstall = ''
    ln -sf qrow $out/bin/qrw
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Query rows in tables, documents and databases from the terminal or through an AI assistant";
    longDescription = ''
      qrow opens CSV, TSV, JSON, JSONL, YAML, TOML, Markdown, Parquet, Arrow,
      Excel, SQLite and DuckDB files as a table and lets you filter, sort, pivot,
      join, add computed columns and draw charts without leaving the terminal.
      Started with --mcp it is an MCP server, so an AI assistant can compute over
      the same files. Formerly called tuitab.
    '';
    homepage = "https://qrow.dev";
    changelog = "https://github.com/denisotree/qrow/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "qrow";
    maintainers = with lib.maintainers; [ denisotree ];
    platforms = lib.platforms.unix;
  };
})
