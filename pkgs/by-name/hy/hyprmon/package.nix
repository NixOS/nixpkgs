{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:
buildGo126Module (finalAttrs: {
  pname = "hyprmon";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "erans";
    repo = "hyprmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1rtmToVveAkNRqPR1gDCYIOS+nM9Ag+3T5QYJmdtbEg=";
  };

  vendorHash = "sha256-U2fw/1tnRwmd9qzEcrMduZbbNU67NbDhG2Id5IHj5js=";

  meta = {
    description = "TUI monitor configuration tool for Hyprland with visual layout, drag-and-drop, and profile management";
    inherit (finalAttrs.src.meta) homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onatustun ];
    mainProgram = "hyprmon";
    platforms = lib.platforms.linux;
  };
})
