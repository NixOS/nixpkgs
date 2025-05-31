{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-ol2jILlSmCVLieNzyo4UnzeIn+Xy2Sh03ZyfG2oABcM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-t9iGHmwB533Jk5sJ6XmOg2OVaD+PgsKaQQ66QjQxdNY=";

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
