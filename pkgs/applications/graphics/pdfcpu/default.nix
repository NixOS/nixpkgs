{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ts4FJWUeWHVfeBEetgACYMGEsDLHm5JOEEn7EtQduPU=";
  };

  vendorSha256 = "sha256-p/2Bu5h2P3ebgvSC12jdR2Zpd27xCFwtB/KZV0AULAM=";

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
