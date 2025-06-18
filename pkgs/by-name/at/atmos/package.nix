{
  lib,
  buildGoModule,
  fetchFromGitHub,
  terraform,
}:

buildGoModule (finalAttrs: {
  pname = "atmos";
  version = "1.178.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = "atmos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5rChYMwRtJt6jvgzJoU7OkgheJML2vgY/NhJsSE/KCI=";
  };

  vendorHash = "sha256-0vHX4P33o6HMQ9k4Awd9+sDoLhbq/8YzrW7dkUeoR7Y=";

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
