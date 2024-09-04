{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-yhlkvvNkZtpVx2uZVvXjr3eqBFXHDJ5qyO6k5EPNfww=";
  };

  vendorHash = "sha256-gZYQEJAlm8qslHGfUsA8np43zdiPDYyhKm8HZIBR3ys=";

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    changelog = "https://github.com/StyraInc/regal/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
