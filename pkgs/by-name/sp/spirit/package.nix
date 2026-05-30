{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "spirit";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "block";
    repo = "spirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6hdsJ20nI85ngDC6trA+85mMPAq9hT9bgBvkRzdONlE=";
  };

  vendorHash = "sha256-bJCwHmt8P6pnnIehYh8nBMHsB6Kff532c3mUTbtrogc=";

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
