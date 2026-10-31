{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "misconfig-mapper";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zbdmSjFJHETEHpUX78RniMpr1jaH0MmUD/qCJXTOCck=";
  };

  vendorHash = "sha256-fh6IoeCpYn8bzdh7oeRlm02WQMEPf1VEjAjtI8bpDys=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
})
