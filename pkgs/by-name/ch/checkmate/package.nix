{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FxBDeFdLORh76oHqrB+NXhz2nVH4bHJEF7ioSx+fngM=";
  };

  vendorHash = "sha256-RM1jgnnCdGb06Uu7xoujjVjhYZSjGozesg+DFOjib1I=";

  subPackages = [ "." ];

  meta = {
    description = "Pluggable code security analysis tool";
    mainProgram = "checkmate";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
