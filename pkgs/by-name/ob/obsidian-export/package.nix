{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "25.3.0";

  src = fetchFromGitHub {
    owner = "zoni";
    repo = "obsidian-export";
    rev = "v${version}";
    hash = "sha256-FcySNccDVeftX5BKVwYXdufsCmG8YuFBQrbSqibbVV8=";
  };

  cargoHash = "sha256-2rP1ks+47fI5Os7ltktPVUzvYss+KkjftrE4G0cl8XI=";

  meta = {
    changelog = "https://github.com/zoni/obsidian-export/blob/${src.rev}/CHANGELOG.md";
    description = "Rust library and CLI to export an Obsidian vault to regular Markdown";
    homepage = "https://github.com/zoni/obsidian-export";
    license = lib.licenses.bsd2Patent;
    mainProgram = "obsidian-export";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
