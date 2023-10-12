{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dEAlOKjNXL7zqlll6lqGmbopjdplDR3ewMMNu9TMsmw=";
  };

  vendorHash = "sha256-WZsm2wiKedMP0miwnzhnSrF7Qw+jqd8dnpcehlsdMCA=";

  # No tests
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    echo checking the version print of pdfcpu
    $out/bin/pdfcpu version | grep ${version}
  '';

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
