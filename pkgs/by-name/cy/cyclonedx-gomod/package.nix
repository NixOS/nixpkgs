{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cyclonedx-gomod";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9EjmYoOBn8BbSo+1L+9AO0Q2G7UmY6lp2LobJhKACu4=";
  };

  vendorHash = "sha256-py0K2ReoWY7q19P3VJE8jtDZ/1EgMPNIVnCs2/nz7wg=";

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
