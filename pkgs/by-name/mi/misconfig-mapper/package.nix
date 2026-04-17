{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "misconfig-mapper";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U4zr+5TD8/rjCv1Ldmie52FZulfohfud72Gyivj2Zko=";
  };

  vendorHash = "sha256-eQetkCrVlYtiXezFzj35TnYAt6tntzUuJHqRvWEkuC4=";

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
