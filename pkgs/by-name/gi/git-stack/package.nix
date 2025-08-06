{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  git-stack,
  stdenv,
  zlib,
}:
rustPlatform.buildRustPackage rec {
  pname = "git-stack";
  version = "0.10.19";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-oJ24qNL0Lw0MC8+YHbnCW2Mbpu2N04e0QG3LpLbYH4M=";
  };

  cargoHash = "sha256-kjyJeKeFtETowTehQEjN58YoqYFUBt9yQlRIcNY0hso=";

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      zlib
    ];

  # Many tests try to access the file system.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = git-stack;
  };

  meta = {
    description = "Stacked branch management for Git";
    homepage = "https://github.com/gitext-rs/git-stack";
    changelog = "https://github.com/gitext-rs/git-stack/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stehessel ];
    mainProgram = "git-stack";
  };
}
