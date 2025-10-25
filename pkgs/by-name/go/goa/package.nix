{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.22.6";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-gDcdk5xRb/CeX5PlfgxTOLru1GHcU3fbFzISPhqe/u4=";
  };
  vendorHash = "sha256-k1tKdU7QWgei8X+mhAYAZwRDkwInPFNyvKZcISjUGIg=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
