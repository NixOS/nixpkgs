{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pushgateway";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Mc4yEd9CRfLZ4ZpcMnwQpoIXQpUerdxYD90FWRBzS20=";
  };

  vendorHash = "sha256-O/Vgn3WC0ZzRy5L/m0qR970joGtqQWWlmethoHAypgY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Branch=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests = {
    inherit (nixosTests.prometheus) pushgateway;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    mainProgram = "pushgateway";
    homepage = "https://github.com/prometheus/pushgateway";
    changelog = "https://github.com/prometheus/pushgateway/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
})
