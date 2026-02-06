{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-opnsense-exporter";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "AthennaMind";
    repo = "opnsense-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+o7zvCJypzbBdZQWlTosauvdk1E207H75+fjtE/Ckk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
  ];
  vendorHash = null;
  passthru.updateScript = nix-update-script { };
  doInstallCheck = true;
  meta = {
    changelog = "https://github.com/AthennaMind/opnsense-exporter/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/AthennaMind/opnsense-exporter";
    description = "Prometheus exporter for opnsense firewall appliances";
    license = lib.licenses.asl20;
    mainProgram = "opnsense-exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
