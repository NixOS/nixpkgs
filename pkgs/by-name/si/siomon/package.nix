{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "siomon";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "level1techs";
    repo = "siomon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wNpvQ+U+QKPww6IqLhvhU8+g5PGBxHe1nV2XjACIrWA=";
  };

  cargoHash = "sha256-mvazC096lhQJ8X5X1tVk0kl5uFWHWuxmzJq3oRNzTKY=";

  meta = {
    description = "Hardware information and real-time sensor monitoring tool for Linux";
    homepage = "https://github.com/level1techs/siomon";
    changelog = "https://github.com/level1techs/siomon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sheevy ];
    mainProgram = "sio";
  };
})
