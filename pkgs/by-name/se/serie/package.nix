{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-BzawNeRdZ6YfjHwnGzKTJYc6mmRBOADGo86ebKY3xbo=";
  };

  cargoHash = "sha256-UpJoNfDPugcPXkJR/zBslemnzaA54Mt1Q1BZerryQSs=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = with lib; {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
