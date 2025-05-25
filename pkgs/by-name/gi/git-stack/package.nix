{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  git-stack,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-kjyJeKeFtETowTehQEjN58YoqYFUBt9yQlRIcNY0hso=";

  # Many tests try to access the file system.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = git-stack;
  };

  meta = with lib; {
    description = "Stacked branch management for Git";
    homepage = "https://github.com/gitext-rs/git-stack";
    changelog = "https://github.com/gitext-rs/git-stack/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ stehessel ];
    mainProgram = "git-stack";
  };
}
