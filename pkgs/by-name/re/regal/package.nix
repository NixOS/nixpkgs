{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-QfxgfwBGAib+mqT2v/8/rhl5Ufjwjf9BouCTYqs6wlw=";
  };

  vendorHash = "sha256-5ImRjMPl+qc2iQEXg9OzKphPpRXhjYvu+1q1ol3M8Yg=";

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    changelog = "https://github.com/StyraInc/regal/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
