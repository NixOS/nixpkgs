{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, testers
, git-stack
}:

rustPlatform.buildRustPackage rec {
  pname = "git-stack";
  version = "0.10.14";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-DAvvVI3npHM7ln/EAr0RjtUCqCoKx9QHsCw69F8C8p4=";
  };

  cargoHash = "sha256-KDVHSCQx7qIS/Gwx/wlpdIMgirPSfG535dvu33gjF7c=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
  };
}
