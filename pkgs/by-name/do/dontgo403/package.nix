{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dontgo403";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = "dontgo403";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AkzXTr46blM1WT89J+H0UlqAaix8Dme31i+ejTx2g1s=";
  };

  vendorHash = "sha256-zAkS0o+wOQLmCil7Lh7DIZCcHYiceb1KwiK/vkSYYwk=";

  ldflags = [
    "-w"
    "-s"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool to bypass 40X response codes";
    mainProgram = "nomore403";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
