{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprlux";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "amadejkastelic";
    repo = "Hyprlux";
    tag = finalAttrs.version;
    hash = "sha256-ZVxGnq2X8Cts/tVLtoQlZd+2ikVLVI12Vl3y75CutaY=";
  };

  cargoHash = "sha256-JhLW3H2e+lNgZfWObZIMHx5CZd9Eqoy7O7fxFTyj5jU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland utility that automates vibrance and night light control";
    homepage = "https://github.com/amadejkastelic/Hyprlux";
    changelog = "https://github.com/amadejkastelic/Hyprlux/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "hyprlux";
  };
})
