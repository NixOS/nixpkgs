{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperlink";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "untitaker";
    repo = "hyperlink";
    rev = version;
    hash = "sha256-QejpyleugPWvr4p8JOMieswVtfQMGxtH+fb46mRLlH4=";
  };

  cargoHash = "sha256-d0JwxxI6Quyan2lgymxGpROKR757LEOUIgJcs5c9Kmc=";

  meta = with lib; {
    description = "Very fast link checker for CI";
    homepage = "https://github.com/untitaker/hyperlink";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "hyperlink";
  };
}
