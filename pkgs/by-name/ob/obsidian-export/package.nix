{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "23.12.0";

  src = fetchFromGitHub {
    owner = "zoni";
    repo = "obsidian-export";
    rev = "v${version}";
    hash = "sha256-r5G2XVV2F/Bt29gxuTZKX+KxH6RFa1hJNH3gSTi7yCU=";
  };

  cargoHash = "sha256-lkqoMFasHpfhmVd3dlYd/TKIBIDzqMbsxfigpeJq0w8=";

  meta = {
    changelog = "https://github.com/zoni/obsidian-export/blob/${src.rev}/CHANGELOG.md";
    description = "Rust library and CLI to export an Obsidian vault to regular Markdown";
    homepage = "https://github.com/zoni/obsidian-export";
    license = lib.licenses.bsd2Patent;
    mainProgram = "obsidian-export";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
