{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-L5r8ds5Avh6WqiYYg/0hVDjdp/TBGgCZgKnJoDzs7Rw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d2I4RDo/U+69WwXjxHRsRNUxY2ymxzHqObR6X68xXRo=";

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
