{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "glas";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "maurobalbi";
    repo = "glas";
    rev = "v${version}";
    sha256 = "sha256-y1sPDCHIfECEhKP6EQs3kDrX/yM+ni0irfPe1c50jJU=";
  };

  cargoHash = "sha256-h27NqsVOW+LM83xtSAV7cvlRbznGE87aJb2/WeSmfOY=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/glas --help > /dev/null
  '';

  meta = {
    description = "A language server for the Gleam programming language.";
    homepage = "https://github.com/maurobalbi/glas";
    changelog = "https://github.com/maurobalbi/glas/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "glas";
    maintainers = with lib.maintainers; [ bhankas ];
  };
}
