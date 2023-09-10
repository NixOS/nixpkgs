{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atmos";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6NUuKU8KQBfHE6fcN3a9lBcUk7p5I9SuY9g+qJxGXmU=";
  };

  vendorSha256 = "sha256-vZwADD7fi9ZvJby9Ijdeueid8jRfUyyj6Nu4kgkO5Wo=";

  ldflags = [ "-s" "-w" "-X github.com/cloudposse/atmos/cmd.Version=v${version}" ];

  preCheck = ''
    # Remove tests that depend on a network connection.
    rm -f pkg/vender/component_vendor_test.go
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

