{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "payme";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "payme";
    rev = "v${version}";
    hash = "sha256-WE/sAs0VSeb5UKkUy1iyjyXtgDmlQhdZkw8HMMSbQiE=";
  };

  vendorHash = null;

  meta = {
    description = "QR code generator (ASCII & PNG) for SEPA payments";
    mainProgram = "payme";
    homepage = "https://github.com/jovandeginste/payme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cimm ];
  };
}
