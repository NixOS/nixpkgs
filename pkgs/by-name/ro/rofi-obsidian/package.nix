{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "rofi-obsidian";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Nydragon";
    repo = "rofi-obsidian";
    rev = "c8f34e424a59b8a15bc77152462d59cfff7fc20e";
    hash = "sha256-t/neFiLdrA37jknLEsHmWhCug5BS40HgQpQ5a1svtQw=";
  };

  cargoHash = "sha256-Eikzn7ZMsrujBdzmsiHGSYAJ+kGBgQAaiVJzixHknWM=";

  meta = {
    description = "Launch your Obsidian vaults from the comfort of rofi";
    homepage = "https://github.com/Nydragon/rofi-obsidian";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nydragon ];
    mainProgram = "rofi-obsidian";
  };
}
