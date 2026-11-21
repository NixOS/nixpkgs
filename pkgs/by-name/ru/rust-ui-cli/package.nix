{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-ui-cli";
  version = "0.3.12";

  src = fetchCrate {
    pname = "ui-cli";
    inherit (finalAttrs) version;
    hash = "sha256-z1XbZ4dU5pdFhhdUVKbfmcnPKuqYkwE4AivRks9t+fc=";
  };

  cargoHash = "sha256-CyYhfG5a8DBetIPA+C7X4ZfkxI9dfCqOP1jMd3TlD4o=";

  # Integration tests make HTTP requests to the rust-ui registry
  doCheck = false;

  meta = {
    description = "CLI to add rust-ui components to your Leptos project";
    longDescription = ''
      A command-line tool for the rust-ui component library. Provides commands
      to initialise projects, browse and install components, diff installed
      components against the registry, and start an MCP server for AI editor
      integration (Claude Code, Cursor, VS Code).
    '';
    homepage = "https://rust-ui.com/docs/components/cli";
    changelog = "https://github.com/rust-ui/ui/blob/main/crates/ui-cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vrashabh-sontakke ];
    mainProgram = "ui";
  };
})
