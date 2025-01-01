{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "hyprsome";
  version = "0.1.12-unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "sopa0";
    repo = "hyprsome";
    rev = "985e1a3b03b5118c98c03983f60ea9f74775858c";
    hash = "sha256-JiOV9c23yOhaVW2NHgs8rjM8l9qt181Tigf5sCnPep8=";
  };

  cargoHash = "sha256-Jqx77/PDWEJ+NPJN2R6n4w9nVPXQoHeuVfYKUB3i9Lg=";

  meta = {
    description = "Awesome-like workspaces for Hyprland";
    homepage = "https://github.com/sopa0/hyprsome";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bhasherbel ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprsome";
  };
}
