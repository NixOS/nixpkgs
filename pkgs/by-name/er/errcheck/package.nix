{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "errcheck";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    hash = "sha256-KEDUXZ720fntrQ8XIpbArU8Q1xEiOw32nYcNhXnQO7Q=";
  };

  vendorHash = "sha256-rO2FoFksN3OdKXwlJBuISs6FmCtepc4FDLdOa5AHvC4=";

  subPackages = [ "." ];

  meta = {
    description = "Checks for unchecked errors in go programs";
    mainProgram = "errcheck";
    homepage = "https://github.com/kisielk/errcheck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
