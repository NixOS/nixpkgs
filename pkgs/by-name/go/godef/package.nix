{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "godef";
  version = "1.2.0";
  rev = "v${version}";

  subPackages = [ "." ];

  vendorHash = "sha256-WjOPmkzOZC0cXOJKAU6iU/Y+NzBv6fHB8xwNMKDnhvY=";

  doCheck = false;

  src = fetchFromGitHub {
    inherit rev;
    owner = "rogpeppe";
    repo = "godef";
    sha256 = "sha256-0qmKn0TIrRH3B54/7/XB1zjaVA4R3LbbsPzLByfEJuo=";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    mainProgram = "godef";
    homepage = "https://github.com/rogpeppe/godef/";
    maintainers = with lib.maintainers; [
      vdemeester
      rvolosatovs
    ];
    license = lib.licenses.bsd3;
  };
}
