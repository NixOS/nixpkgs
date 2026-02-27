{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pik";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = finalAttrs.version;
    hash = "sha256-SXSMYvpFLT4sYb1UxC4SoOXL5J2V0/hSL5p2Wa/Ba00=";
  };

  cargoHash = "sha256-+7sUlqi3cv3GksVMMCgrcbGgkCIQZCWEco5LpXo7p2w=";

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
