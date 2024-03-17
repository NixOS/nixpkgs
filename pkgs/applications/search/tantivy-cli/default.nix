{ lib
, fetchFromGitHub
, rustPlatform
, testers
, tantivy-cli
}:
rustPlatform.buildRustPackage rec {
  pname = "tantivy-cli";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = pname;
    rev = version;
    hash = "sha256-+UXN0nPmXMDQSAEhADb6GNYz5WhaxV35HjQMbuUodMk=";
  };

  cargoHash = "sha256-/LIgM1UwR6xY2izZNOg6rKYNUYJ+HK1tOY1X9LLaN18=";

  passthru.tests.version = testers.testVersion {
    package = tantivy-cli;
  };

  meta = with lib; {
    description = "Command line interface for the tantivy search engine";
    homepage = "https://github.com/quickwit-oss/tantivy-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "tantivy-cli";
  };
}
