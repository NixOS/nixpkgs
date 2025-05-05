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

  useFetchCargoVendor = true;
  cargoHash = "sha256-+PJ8KpkdJmxJ0hhoecg9m5vqhgi73FmHfwZVBU4UF4w=";

  meta = {
    description = "Launch your Obsidian vaults from the comfort of rofi";
    homepage = "https://github.com/Nydragon/rofi-obsidian";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nydragon ];
    mainProgram = "rofi-obsidian";
  };
}
