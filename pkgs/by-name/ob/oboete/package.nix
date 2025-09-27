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
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
    hash = "sha256-npvv2ZuMoZJnuwzRzbH+kQ5/IjlS6QuLi2rDmKwSoWQ=";
  };

  cargoHash = "sha256-hOvITZJfFyJbCV9+SuyVVwsY1/OGRXlJeKB/opVGrnI=";

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
