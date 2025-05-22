{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-uehrEHTjzgJxzkBPJRZ75rOLcjjBnC80kcMsZdnksoo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K+3VjGwD12ANZHvU/KCVCFJwODXyp27/e6E6AB0mxTo=";

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
