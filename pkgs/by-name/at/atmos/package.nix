{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "atmos";
  version = "1.227.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = "atmos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wFM7jLBEqKFCBSUIghTXbxPmlKHr/ZxAZN1izuTq7Co=";
  };

  vendorHash = "sha256-Gs90dEuk2uq2MbT/05g4x73FPOmZhJjWBxLmxe37vlg=";

  env.CGO_ENABLED = 0; # Compiles a pure statically linked Go binary.

  subPackages = [ "." ]; # Speeds up the build.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudposse/atmos/pkg/version.Version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ versionCheckHook ];

  preCheck = ''
    # Remove tests that depend on a network connection.
    rm -f \
      main_hooks_and_keychain_store_integration_test.go \
      main_hooks_and_store_integration_test.go \
      main_plan_diff_integration_test.go \
      pkg/atlantis/atlantis_generate_repo_config_test.go \
      pkg/describe/describe_affected_test.go \
      pkg/vender/component_vendor_test.go
  '';

  doInstallCheck = true;

  meta = {
    homepage = "https://atmos.tools";
    changelog = "https://github.com/cloudposse/atmos/releases/tag/v${finalAttrs.version}";
    description = "Universal Tool for DevOps and Cloud Automation (works with terraform, helm, helmfile, etc)";
    mainProgram = "atmos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nevivurn ];
  };
})
