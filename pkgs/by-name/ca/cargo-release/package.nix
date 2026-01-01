{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  curl,
  git,
<<<<<<< HEAD
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-release";
  version = "0.25.22";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-NFI7UIHbo1xcH+pXim3ar8hvkn2EdIFpI2rpsivhVHg=";
  };

  cargoHash = "sha256-RJfg11FyecDKFIsXx5c3R/qC5c81N3WYjd2pU4sw/ng=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  nativeCheckInputs = [
    git
  ];

  # disable vendored-libgit2 and vendored-openssl
  buildNoDefaultFeatures = true;

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    mainProgram = "cargo-release";
    homepage = "https://github.com/crate-ci/cargo-release";
<<<<<<< HEAD
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${finalAttrs.version}/CHANGELOG.md";
=======
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      gerschtli
<<<<<<< HEAD
      progrm_jarvis
    ];
  };
})
=======
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
