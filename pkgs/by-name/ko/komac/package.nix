{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, testers
, komac
}:

let
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-L8UYpNqjRyqf4hPQwD9LaXWu6jYaP34yTwTxcqg+e2U=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  cargoHash = "sha256-J4QZzbyDr4SDt6LlAy9ZdpqgIufZCZHmOC9eu70wMsM=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  passthru.tests.version = testers.testVersion {
    inherit version;

    package = komac;
    command = "komac --version";
  };

  meta = with lib; {
    description = "The Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kachick ];
    mainProgram = "komac";
  };
}
