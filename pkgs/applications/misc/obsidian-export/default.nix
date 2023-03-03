{ lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "22.11.0";

  src = builtins.fetchGit {
    url = "https://github.com/zoni/obsidian-export.git";
    ref = "refs/tags/v${version}";
    rev = "83ab69aedd7480e60d3498d7bb6490d9972e1e32";
  };

  cargoSha256 = "sha256-XYk7AW02Hhn6SVX6UQpZ054N1xXdQFS8XxllWMMxumY=";

  meta = with lib; {
    description = "Rust library and CLI to export an Obsidian vault to regular Markdown";
    homepage = "https://github.com/zoni/obsidian-export";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with maintainers; [ berryp ];
  };
}
