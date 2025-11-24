{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "clusterlint";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "clusterlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zNrGWXKVpkr4NtDmawkICGy0l8foNr40zcdsdsKVAGY=";
  };

  vendorHash = null;

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  # One subpackage fails to build
  excludedPackages = [ "example-plugin" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Best practices checker for Kubernetes clusters";
    homepage = "https://github.com/digitalocean/clusterlint";
    changelog = "https://github.com/digitalocean/clusterlint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "clusterlint";
  };
})
