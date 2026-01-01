{
  lib,
<<<<<<< HEAD
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  just,
=======
  rustPlatform,
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libcosmicAppHook,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oboete";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.1.13";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
<<<<<<< HEAD
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

=======
    hash = "sha256-C6ymeI1t0UaX9EzUEz/5mQNEU8vfHueU7kuu9waXV5k=";
  };

  cargoHash = "sha256-QMcB3+KCefffbmyvkDoO6UvwwQgiDPwvae/jg4/XSO0=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [ sqlite ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
