{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.21.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-LDgpwSMB6TBdq4UwxNtddIH5KWkQSsgh3ok5JJNfwRw=";
  };
  vendorHash = "sha256-Mu93LchlPSU05r/zwZ+q0wgwWF2cTQEjOupr9lmuqVU=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
