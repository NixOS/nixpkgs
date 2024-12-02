{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple64-netplay-server";
  version = "2024.10.1";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64-netplay-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-p9hHVf1LD95w280ScUkxHKmBJLJ9eiH3WEYV+kaALgQ=";
  };

  vendorHash = "sha256-HeYA/nR0NuP/fPMJXGGuN2eP6vB4yj1yWFfFDyp34QE=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/simple64/simple64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
