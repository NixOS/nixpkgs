{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l3vJDF2c6h/trfnAGxu7XEoDoj7bB4tATBUlxKFYfUs=";
  };

  vendorSha256 = "sha256-611eLYm+OPIdmax2KwYNjuQEGqyZd6SXvhUHzRdLzaI=";

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
