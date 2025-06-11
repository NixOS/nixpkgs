{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "govc";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "govmomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q1I3UWl/LiIzRNsN5D2b2z+03kT95IVYob2g1uSyaHk=";
  };

  vendorHash = "sha256-N5BWw754Why6Qo/EM1RfU6uR7jxo7+oAL9YZMNCOFoE=";

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
