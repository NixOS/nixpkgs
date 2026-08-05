{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "spirit";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "block";
    repo = "spirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kcFNDW02ReUEbwLVos2Jth/bSAEAWZZ1Tpv3xpxY9jE=";
  };

  vendorHash = "sha256-qgLmkZ1pYvnZ5lr9GCvg9mC8oW/34BjoFXY3NKzpRwA=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/block/spirit";
    description = "Online schema change tool for MySQL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
})
