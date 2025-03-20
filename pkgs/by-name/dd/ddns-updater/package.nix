{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "ddns-updater";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "qdm12";
    repo = "ddns-updater";
    rev = "v${version}";
    hash = "sha256-Vvk3owtSpwstmC5UaVyUEY+FW25KA+nYp2dOqiP4HTs=";
  };

  vendorHash = "sha256-RKaUgE/cdzattMWMxiJ5fIXjx3IKE+On6dT/P6y4wqU=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd/ddns-updater" ];

  passthru = {
    tests = {
      inherit (nixosTests) ddns-updater;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Container to update DNS records periodically with WebUI for many DNS providers";
    homepage = "https://github.com/qdm12/ddns-updater";
    license = licenses.mit;
    maintainers = with maintainers; [ delliott ];
    mainProgram = "ddns-updater";
  };
}
