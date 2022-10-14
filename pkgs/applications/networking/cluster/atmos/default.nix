{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atmos";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/rxGAfYjV5VzYs9h8eCpz5jhmW7jPdk1XB3bXHH+oQw=";
  };

  vendorSha256 = "sha256-/b764auKkZF0oMqNlXmsW9aB5gcq4WFQRFjsVhNDiB4=";

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

