{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "govc";
  version = "0.53.1";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "govmomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-egyXzA+0xobHcq3dGOYou4sPCHRDv2l8QWo8ZLWofKU=";
  };

  vendorHash = "sha256-xRhjAOQKX6CU9BmdNZonDMwmnEvFXWOaP73j7wPIexk=";

  sourceRoot = "${finalAttrs.src.name}/govc";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware/govmomi/govc/flags.BuildVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "VSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/main/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
    mainProgram = "govc";
  };
})
