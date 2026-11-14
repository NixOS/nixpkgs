{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-workspaces";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-workspaces";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4gYScRmoY54O7fOYSW29BBaCGuuKq+WyK97cWa2OaW0=";
  };

  cargoHash = "sha256-Saagyuzx2dTo0AiQitnVASLEbDZYZdhWLmwC3K2TDRI=";

  meta = {
    description = "Multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      kiike
      donovanglover
    ];
    mainProgram = "hyprland-workspaces";
  };
})
