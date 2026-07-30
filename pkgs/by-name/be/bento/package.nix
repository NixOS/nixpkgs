{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bento";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "warpstreamlabs";
    repo = "bento";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ZISLZzh8FYAE9riZ5Ya5h3LhwzHK4a5jJl8jeHiNoA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-h9bH5aewbDAuOVAps3TMihjCITFiBT/bbqNJCUT0NN8=";

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
