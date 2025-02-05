{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
  testers,
  git-stack,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-stack";
  version = "0.10.18";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-iFoxYq4NHC/K0ruPDXHfayZDglebBJE00V57HUH9Y84=";
  };

  cargoHash = "sha256-kX0eOqp3emGEYZPIzkP62WpfH8mTxMi7zB+nwtpSFuk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

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
