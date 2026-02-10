{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "govc";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "govmomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gd8Th9cEpPwKlJfjUkDjZXzOzl/nhr+GgPjGuIR6Xlg=";
  };

  vendorHash = "sha256-31n3pBAK/zZ7ZbQ9GxLNyO0Tw4K2xgvxKfPDb7x/lTk=";

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
