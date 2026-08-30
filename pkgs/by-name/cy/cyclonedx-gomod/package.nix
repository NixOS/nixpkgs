{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cyclonedx-gomod";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lTIgASBf+mbbsugRDYlPIeNoIrhGwftpoB+lKj/9H44=";
  };

  vendorHash = "sha256-BtSBlkdEgJNJ1JWK33FIWMLfxbEDgx8mv36Mx2QesA4=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access and cyclonedx executable
  doCheck = false;

  meta = {
    description = "Tool to create CycloneDX Software Bill of Materials (SBOM) from Go modules";
    homepage = "https://github.com/CycloneDX/cyclonedx-gomod";
    changelog = "https://github.com/CycloneDX/cyclonedx-gomod/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cyclonedx-gomod";
  };
})
