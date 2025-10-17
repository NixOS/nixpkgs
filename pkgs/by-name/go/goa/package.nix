{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.22.5";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-VeRA2J+NQoq5F/SiRuT9jRD19oKN42oTeRfF+WzI0MA=";
  };
  vendorHash = "sha256-FRR+4rYMed5yxWAdCz3hHsRpSA8rPls1hshU/0vIJ0g=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
