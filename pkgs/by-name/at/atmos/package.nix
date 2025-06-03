{
  lib,
  buildGoModule,
  fetchFromGitHub,
  terraform,
}:

buildGoModule (finalAttrs: {
  pname = "atmos";
  version = "1.176.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = "atmos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dqCjbaGDIbJyi44OFz4Xuu5fy0jJp1URidO2EV6pD4U=";
  };

  vendorHash = "sha256-fk74wLJuRVtw/mOyI2GIyXcX/cC/VX6Bx1rDRFsz95M=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudposse/atmos/cmd.Version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ terraform ];

  preCheck = ''
    # Remove tests that depend on a network connection.
    rm -f \
      pkg/vender/component_vendor_test.go \
      pkg/atlantis/atlantis_generate_repo_config_test.go \
      pkg/describe/describe_affected_test.go
  '';

  # depend on a network connection.
  doCheck = false;

  # depend on a network connection.
  doInstallCheck = false;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/atmos version | grep "v${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://atmos.tools";
    changelog = "https://github.com/cloudposse/atmos/releases/tag/v${finalAttrs.version}";
    description = "Universal Tool for DevOps and Cloud Automation (works with terraform, helm, helmfile, etc)";
    mainProgram = "atmos";
    license = lib.licenses.asl20;
    teams = [ lib.teams.cloudposse ];
  };
})
