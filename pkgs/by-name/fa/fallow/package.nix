{
  lib,
  fetchFromGitHub,
  gitMinimal,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fallow";
  version = "2.101.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fallow-rs";
    repo = "fallow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NrEyMOkutqBmJ6g/t3QWNvhjlxYmH7/lWOeoLRarKIk=";
  };

  cargoHash = "sha256-DDVyKPF0w3Zzg491Pxmq5aMxosJ6y4fV5IjzoskvhGI=";

  # Build the three user-facing binaries: the CLI, the language server, and the
  # MCP server. Editor and agent integrations launch `fallow-lsp` and
  # `fallow-mcp` directly, so a system package that ships only the CLI cannot
  # wire them up. The build is scoped to these bins because crates/cli also
  # produces internal helper binaries (stub_sidecar, fallow-schema-emit) that
  # are not part of the public interface.
  cargoBuildFlags = [
    "--bin"
    "fallow"
    "--bin"
    "fallow-lsp"
    "--bin"
    "fallow-mcp"
  ];

  # Keep the check phase on the CLI crate, which exercises the shared analysis
  # core. Its integration tests create temporary fixture projects and expect
  # Git discovery to find a parent repository for hotspot analysis (see
  # preCheck).
  cargoTestFlags = [
    "-p"
    "fallow-cli"
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    # Some integration tests create temporary fixture projects and expect Git
    # discovery to find a parent repository for hotspot analysis.
    git init "$TMPDIR"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  # versionCheckHook only covers mainProgram; confirm the language server and
  # MCP server were installed and are runnable too.
  postInstallCheck = ''
    $out/bin/fallow-lsp --version
    $out/bin/fallow-mcp --version
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust-native codebase intelligence for TypeScript and JavaScript";
    homepage = "https://docs.fallow.tools";
    changelog = "https://github.com/fallow-rs/fallow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bartwaardenburg ];
    mainProgram = "fallow";
  };
})
