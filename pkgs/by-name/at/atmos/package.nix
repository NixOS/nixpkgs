{
  lib,
  buildGoModule,
  fetchFromGitHub,
  terraform,
}:

buildGoModule (finalAttrs: {
  pname = "atmos";
  version = "1.171.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = "atmos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4A/sSJhF9syK1Z3HhBy8fXzdXBfAoofwQ+WLYeH1cvw=";
  };

  vendorHash = "sha256-JN6S1ncElUnZ9XEKEsgfYKXWZQpxogf9imopLeXX3ao=";

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
