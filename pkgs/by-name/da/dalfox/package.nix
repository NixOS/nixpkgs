{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${version}";
    hash = "sha256-RJzvsQBsdkuhbGbfGSO/iJXUzdQ7KTeLx9Wntv4p3Hc=";
  };

  vendorHash = "sha256-NQBCsGB3GQ0XPoGQdGDCJs4+Bv2Gu3JZj85ESoLiFVg=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
