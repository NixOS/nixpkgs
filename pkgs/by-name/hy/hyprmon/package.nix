{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module (finalAttrs: {
  pname = "hyprmon";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "erans";
    repo = "hyprmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dcjEnxSQwXUPJ44gj7pVPQtZUkBXbqLvQgmhYvANz8o=";
  };

  vendorHash = "sha256-n4RZxpsrlSUD3B/GLVoM2CPckvDkbyaMyg6h4QNbuH0=";

  meta = {
    description = "TUI monitor configuration tool for Hyprland with visual layout, drag-and-drop, and profile management";
    homepage = "https://github.com/erans/hyprmon";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onatustun ];
    mainProgram = "hyprmon";
  };
})
