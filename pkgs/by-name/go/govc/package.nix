{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "govc";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "govmomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//OqlBGek/UqxMUgjNDxJ1YkUNoYjeZRx1MIUgJzZys=";
  };

  vendorHash = "sha256-t5yzwXz037umvqxZ/Y9T3Cld3xyA6BOJrDSzCvFdE5o=";

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
