{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-4qqwL+zzBLtN8DLgUsVVAjXKdAvvbo12PHQstptbFIc=";
  };

  vendorHash = "sha256-5rj2dCWya24VUmIFf0oJQop80trq9NnqqFlBW/A6opk=";

  meta = with lib; {
    description = "a linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
