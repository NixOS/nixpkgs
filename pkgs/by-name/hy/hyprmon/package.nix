{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "hyprmon";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "erans";
    repo = "hyprmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fITGGP01RB8h8loClSZ+vuohViJQC8mpSt4iNZVK9yk=";
  };

  vendorHash = "sha256-JahEeFmPYfJVXjbKdfUePI/xF3Ob/c2czFXKCy92ouQ=";

  meta = {
    description = "TUI monitor configuration tool for Hyprland with visual layout, drag-and-drop, and profile management";
    homepage = "https://github.com/erans/hyprmon";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onatustun ];
    mainProgram = "hyprmon";
  };
})
