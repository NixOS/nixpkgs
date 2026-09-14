{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "saucectl";
  version = "0.214.0";

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xMWNuVDXcg0AXa6x8HujOImTWzDT5YU770Eib7GuD18=";
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${finalAttrs.version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${finalAttrs.version}"
  ];

  vendorHash = "sha256-931KJUQq/eSqssDKJa5mL33TLBwBFbz4DT1RDZIiC9Y=";

  checkFlags = [ "-skip=^TestNewRequestWithContext$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command line interface for the Sauce Labs platform";
    changelog = "https://github.com/saucelabs/saucectl/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/saucelabs/saucectl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "saucectl";
  };
})
