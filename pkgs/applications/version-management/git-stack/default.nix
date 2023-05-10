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
  version = "0.10.16";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-QpRgAcbaZP5pgqMCoYAUybp8NkSkfGqNsZYXZp3Zdtc=";
  };

  cargoHash = "sha256-L+GtqbPQCgw0n1aW/2rU8ba+acC5n0sdEl9C6lveb1I=";

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
