{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oboete";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
    hash = "sha256-C6ymeI1t0UaX9EzUEz/5mQNEU8vfHueU7kuu9waXV5k=";
  };

  cargoHash = "sha256-QMcB3+KCefffbmyvkDoO6UvwwQgiDPwvae/jg4/XSO0=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [ sqlite ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
})
