{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "govc";
  version = "0.56.2";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "govmomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sBOsBLYnGQ1OlzBTgSL1SAymwmqtoES2T6ilSsJXlek=";
  };

  vendorHash = "sha256-f5U64vmye2aL9eKU06fmnC2viw34CwriAZyr/RYHC4o=";

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
