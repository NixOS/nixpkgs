{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bento";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "warpstreamlabs";
    repo = "bento";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XFp10TcDDbFe6A5QVvvd2YJqdBe96RmJ/WQIt2SITtg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-TVsRjN/BDLN+8Qt2m70vrd5rx5wE+yUesiUB8i3vPmc=";

  subPackages = [
    "cmd/bento"
    "cmd/serverless/bento-lambda"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/warpstreamlabs/bento/internal/cli.Version=${finalAttrs.version}"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and resilient stream processor";
    homepage = "https://warpstreamlabs.github.io/bento/";
    changelog = "https://github.com/warpstreamlabs/bento/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "bento";
  };
})
