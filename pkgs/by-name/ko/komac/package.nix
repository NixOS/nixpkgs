{ lib
, fetchFromGitHub
, rustPlatform
, testers
, komac
}:

let
  pname = "Komac";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-L8UYpNqjRyqf4hPQwD9LaXWu6jYaP34yTwTxcqg+e2U=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-S9y/SLs763CbLE9OiHYYMOaCrP74HSFiWcaukORLUis=";

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = komac;
    command = "komac --version";
    version = src.rev;
  };

  meta = with lib; {
    description = "The Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/v${src.rev}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kachick ];
    mainProgram = "komac";
  };
}
