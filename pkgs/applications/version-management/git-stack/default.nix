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
<<<<<<< HEAD
  version = "0.10.17";
=======
  version = "0.10.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-stack";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-foItJSZ6jsLuWkO/c1Ejb45dSdzZ/ripieyVIYsEyy0=";
  };

  cargoHash = "sha256-MEhUmy4ijR/zHm/qMt4PqNGYnCfIgjNaL9SlMmXCMmc=";
=======
    hash = "sha256-QpRgAcbaZP5pgqMCoYAUybp8NkSkfGqNsZYXZp3Zdtc=";
  };

  cargoHash = "sha256-L+GtqbPQCgw0n1aW/2rU8ba+acC5n0sdEl9C6lveb1I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
