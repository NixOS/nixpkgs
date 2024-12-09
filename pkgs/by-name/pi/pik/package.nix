{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-q1nNQC9qGa7nUNIaDdqW3wIrfzH7JKS/yZAe9KNmX3k=";
  };

  cargoHash = "sha256-gqzt3cFOS4uzIstIvmPS0n18aFUt0YnoTRz7EVTV7sA=";

  passthru.tests.version = testers.testVersion { package = pik; };

  meta = {
    description = "Process Interactive Kill";
    longDescription = ''
      Process Interactive Kill is a command line tool that helps to find and kill process.
      It works like pkill command but search is interactive.
    '';
    homepage = "https://github.com/jacek-kurlit/pik";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bew ];
    mainProgram = "pik";
  };
}
