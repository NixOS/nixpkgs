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
  version = "0.10.15";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-DUr3kD27wWuWuArVVhGFYHmX7cA5+J1/dGsZIuWh30c=";
  };

  cargoHash = "sha256-4p6vWVVHzjE66mnoXKbZJrh77q40OM49fHwCFCgE0W4=";

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
