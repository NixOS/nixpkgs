{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atmos";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JRvPRlq4H9PcELozlvIE065LSNIxrh/Ej+2GXO8s2x4=";
  };

  vendorHash = "sha256-YBcVsuBL5n5ycaY1a0uxlDKX7YyrtF16gi17wCK1Jio=";

  ldflags = [ "-s" "-w" "-X github.com/cloudposse/atmos/cmd.Version=v${version}" ];

  preCheck = ''
    # Remove tests that depend on a network connection.
    rm -f \
      pkg/vender/component_vendor_test.go \
      pkg/atlantis/atlantis_generate_repo_config_test.go \
      pkg/describe/describe_affected_test.go
  '';

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/atmos version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://atmos.tools";
    changelog = "https://github.com/cloudposse/atmos/releases/tag/v${version}";
    description = "Universal Tool for DevOps and Cloud Automation (works with terraform, helm, helmfile, etc)";
    license = licenses.asl20;
    maintainers = with maintainers; [ rb ];
  };
}
