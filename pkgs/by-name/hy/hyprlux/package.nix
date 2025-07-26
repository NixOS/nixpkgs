{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprlux";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "amadejkastelic";
    repo = "Hyprlux";
    tag = finalAttrs.version;
    hash = "sha256-t5IBNLpQ523yOa5zFHH05kpGLHmaCIUo7IVKVZKrq+M=";
  };

  cargoHash = "sha256-7cysWpUAeOwpwj0Fbvq3hdIeDP2jZdTaMPL90EhLzHA=";

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
