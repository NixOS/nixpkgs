{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-uvfCMXCbU0SGia1lLz9jkPnZ9Nmohd3sTgxHUbW6/Y8=";
  };

  cargoHash = "sha256-IQX3lS8Fl6zNKTYlvoPXPzBx+J8bbyH9ZYMzyu2mF9o=";

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
