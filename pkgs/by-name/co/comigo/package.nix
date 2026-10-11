{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "comigo";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7KaZTUrLRMbnLYsKHVMuU5V1XTzckpoMd90/wpkYqsc=";
  };

  vendorHash = "sha256-C7O0GmNSW9MGLiqXh7wwp1sq0hgzfpyPaAWnsymbq6g=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Simple and Efficient Comic Reader";
    homepage = "https://github.com/yumenaka/comigo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "comigo";
  };
})
