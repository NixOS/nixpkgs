{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rx/LUp5s2DhEKuLUklYXjtTXjqBju+5YzK1hNfBCnIE=";
  };

  vendorSha256 = "sha256-/SsDDFveovJfuEdnOkxHAWccS8PJW5k9IHSxSJAgHMQ=";

  # No tests
  doCheck = false;

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
