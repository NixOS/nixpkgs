{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "rofi-obsidian";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Nydragon";
    repo = "rofi-obsidian";
    rev = "0.1.5";
    hash = "sha256-EQ7OGW5FTgfuJ/xJzOhl1eb3XNORUfs0efP17A6yp7g=";
  };

  cargoHash = "sha256-hAiBSAvnMRchH49bku2oPhoCK3+bcWiZW4YbcMuAiqU=";

  meta = {
    description = "Launch your Obsidian vaults from the comfort of rofi";
    homepage = "https://github.com/Nydragon/rofi-obsidian";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nydragon ];
    mainProgram = "rofi-obsidian";
  };
}
