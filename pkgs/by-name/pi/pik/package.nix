{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pik";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = finalAttrs.version;
    hash = "sha256-OFlt1JMuIX1oe6KE/prQJie+DaB+QFjnfYHJEdbIqcI=";
  };

  cargoHash = "sha256-Vg5pXpRSuO4PnN6uJbTrNBvKrmNz4Z8u9AgWtWb9ZYo=";

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
