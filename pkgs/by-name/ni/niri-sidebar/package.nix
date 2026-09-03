{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-sidebar";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Vigintillionn";
    repo = "niri-sidebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MYP1ZiwV9+yJhl0zpuri6NQkQHlaYZjGBhXpZEaPZyI=";
  };

  cargoHash = "sha256-zZlfwAxWE1ZZy6k7QoBOamCGigGShd89sD27vfvgR00=";

  meta = {
    description = "Lightweight, external sidebar manager for the Niri window manager";
    homepage = "https://github.com/Vigintillionn/niri-sidebar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fin444 ];
    mainProgram = "niri-sidebar";
    platforms = lib.platforms.linux;
  };
})
