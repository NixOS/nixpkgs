{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "23.12.0";

  src = fetchFromGitHub {
    owner = "zoni";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r5G2XVV2F/Bt29gxuTZKX+KxH6RFa1hJNH3gSTi7yCU=";
  };

  cargoSha256 = "sha256-lkqoMFasHpfhmVd3dlYd/TKIBIDzqMbsxfigpeJq0w8=";

  meta = with lib; {
    description = "Rust library and CLI to export an Obsidian vault to regular Markdown";
    homepage = "https://github.com/zoni/${pname}";
    changelog = "https://github.com/zoni/obsidian-export/blob/main/CHANGELOG.md";
    license = licenses.bsd2Patent;
    platforms = platforms.linux;
    maintainers = with maintainers; [ programmerino ];
    mainProgram = "obsidian-export";
  };
}
