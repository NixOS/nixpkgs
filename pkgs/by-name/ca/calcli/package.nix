{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "calcli";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Siphcy";
    repo = "calcli";
    rev = "v${version}";
    hash = "sha256-WQHuOzSPrRU/tw1bYZj2JKLTqRyHdSJxtBB89OJ6Q6o=";
  };

  cargoHash = "sha256-XMpYNeu24cQ9dYpmNYwFqFZ54xx4WcYO2jDq0WpEiSQ=";

  meta = with lib; {
    description = "A lightweight TUI scientific calculator with Vi-style keybindings";
    homepage = "https://github.com/Siphcy/calcli";
    license = licenses.mit;
    mainProgram = "calcli";
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
}
