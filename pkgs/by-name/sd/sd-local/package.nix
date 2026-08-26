{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "sd-local";
  version = "1.0.59";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = "sd-local";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-o29VwPC03JQ2JgcZIJBARl9pEDWdE86ExEM3eB7UfDI=";
  };

  vendorHash = "sha256-FVT7zylL1mbwkUH01It9a/P3rC128OnMGqoqE8RMo1k=";

  subPackages = [ "." ];

  meta = {
    description = "screwdriver.cd local mode";
    mainProgram = "sd-local";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ midchildan ];
  };
})
