{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pik";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = finalAttrs.version;
    hash = "sha256-pDfqqQcYrK78OylwOiKc/Orul03MjdZxEHhpr8obm84=";
  };

  cargoHash = "sha256-/2E5VZt2/xWtPy4Zpo8lVn4sXR4Gq6+NJkKpNM7hOVg=";

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
})
