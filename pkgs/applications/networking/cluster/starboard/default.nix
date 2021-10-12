{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6QIQsxqTKERo5x2Knv4IBeNt5KjvfoW0ryFJLlALqrA=";
  };

  vendorSha256 = "sha256-r6wMSeW5Et6hYwoEKufmcOmucuHlYuBDOMuXXMT4W2Y=";

  # Don't build and check the integration tests
  excludedPackages = "itest";

  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  preCheck = ''
    # Remove test that requires networking
    rm pkg/plugin/aqua/client/client_integration_test.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/starboard --help
    $out/bin/starboard version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/starboard";
    changelog = "https://github.com/aquasecurity/starboard/releases/tag/v${version}";
    description = "Kubernetes-native security tool kit";
    longDescription = ''
      Starboard integrates security tools into the Kubernetes environment, so
      that users can find and view the risks that relate to different resources
      in a Kubernetes-native way. Starboard provides custom security resources
      definitions and a Go module to work with a range of existing security
      tools, as well as a kubectl-compatible command-line tool and an Octant
      plug-in that make security reports available through familiar Kubernetes
      tools.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
