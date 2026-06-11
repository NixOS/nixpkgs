{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oboete";
  version = "0.2.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
    hash = "sha256-hOOpx1R7U5fJwWPATJaoT7VbODZJWMTg7v4ro00NZZc=";
  };

  cargoHash = "sha256-i2fGYVt3axF74B66ics36xk+17joiArfFJcqkv3v40c=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [ sqlite ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
})
