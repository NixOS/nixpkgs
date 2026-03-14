{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FmYiGAUTdHLBHmMrX4I1Lax+WTevLeW2+TSVhV0TUCk=";
  };

  cargoHash = "sha256-EICrvDm97hXvGbmp6zOMSEKCdJ6MPho2Y0llWQ9zHus=";

  meta = {
    description = "A fast native Rust Mermaid diagram renderer. No browser required. 500-1000x faster than mermaid-cli";
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    changelog = "https://github.com/1jehuang/mermaid-rs-renderer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "mermaid-rs-renderer";
  };
})
