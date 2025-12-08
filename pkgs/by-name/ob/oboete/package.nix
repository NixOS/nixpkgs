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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
    hash = "sha256-yCIZl51Etv/vXJsIMTvUDPhCnkIuenvHjcP0KZXdAiE=";
  };

  cargoHash = "sha256-BWGUzGGm1u64bQLy1rg9+WYNlgeuxcHlKsdIb18yVZA=";

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
