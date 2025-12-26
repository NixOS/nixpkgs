{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  just,
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

  # TODO: Remove in the next update
  patches = [
    (fetchpatch2 {
      name = "fix-oboete-justfile.patch";
      url = "https://patch-diff.githubusercontent.com/raw/mariinkys/oboete/pull/25.diff?full_index=1";
      hash = "sha256-GPrtL73EKQi5fIIWPYcuS3HRwJ4ZHFsHzRYN6pYuUVg=";
    })
  ];

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
