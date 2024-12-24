{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-UOw0bAUvaKpMmFmAAlheALhtgXU2+Df6b/nSRH7bWHc=";
  };
  vendorHash = "sha256-IqzW5fOLLBbpPFTE5PiOISdmp3Gq6b8SUbG4CbbU01s=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
