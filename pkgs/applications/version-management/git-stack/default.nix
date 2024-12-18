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
  version = "0.10.17";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
    hash = "sha256-foItJSZ6jsLuWkO/c1Ejb45dSdzZ/ripieyVIYsEyy0=";
  };

  cargoHash = "sha256-MEhUmy4ijR/zHm/qMt4PqNGYnCfIgjNaL9SlMmXCMmc=";

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
    mainProgram = "git-stack";
  };
}
