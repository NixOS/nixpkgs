{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kbst";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kbst";
    repo = "kbst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tbSYNJp/gzEz+wEAe3bvIiZL5axZvW+bxqTOBkYSpMY=";
  };

  vendorHash = "sha256-+FY6KGX606CfTVKM1HeHxCm9PkaqfnT5XeOEXUX3Q5I=";

  ldflags =
    let
      package_url = "github.com/kbst/kbst";
    in
    [
      "-s"
      "-w"
      "-X ${package_url}.version=${finalAttrs.version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${finalAttrs.src.rev}"
      "-X ${package_url}.gitTag=v${finalAttrs.version}"
      "-X ${package_url}.gitTreeState=clean"
    ];

  doCheck = false;

  meta = {
    description = "Kubestack framework CLI";
    mainProgram = "kbst";
    homepage = "https://www.kubestack.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mtrsk ];
  };
})
