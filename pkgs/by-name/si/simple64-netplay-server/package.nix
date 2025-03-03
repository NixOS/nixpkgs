{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple64-netplay-server";
  version = "2025.02.3";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64-netplay-server";
    tag = "v${version}";
    hash = "sha256-mtyIGS7i4+HRpjE8Z3puoIOGhv21Th27iCXpO2LxtAg=";
  };

  vendorHash = "sha256-lcKOAPCyWKNg+l1YjziaMTn4DjLB0P+dz3FqyAy0sFk=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/simple64/simple64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
