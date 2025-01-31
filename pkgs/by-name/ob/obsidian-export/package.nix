{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "24.11.0";

  src = fetchFromGitHub {
    owner = "zoni";
    repo = "obsidian-export";
    rev = "v${version}";
    hash = "sha256-XIIrJpkDV5TIGGZ7L/TN5bYXV8ra1XOFPb08WSiojPI=";
  };

  cargoHash = "sha256-NZyBYMLEIElOvp0RgYvI5tXk0bvPbmIhuIhls2/+BpQ=";

  meta = {
    changelog = "https://github.com/zoni/obsidian-export/blob/${src.rev}/CHANGELOG.md";
    description = "Rust library and CLI to export an Obsidian vault to regular Markdown";
    homepage = "https://github.com/zoni/obsidian-export";
    license = lib.licenses.bsd2Patent;
    mainProgram = "obsidian-export";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
