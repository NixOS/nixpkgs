{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dalfox";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0amVlnLwwb7YAUbTce9gRmjv3W1FMgc2/XZQKCettTY=";
  };

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
})
