{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "opnborg";
  version = "0.1.66";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    rev = "v${version}";
    hash = "sha256-7WYDkAHhCrVghNd+77XfwF1WwYJ8azt0Twn4d/rDjU8=";
  };

  vendorHash = "sha256-i9MDtaR5uTrIhpliCyK/WMZqT69TyPVLQI9AGHCWavU=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
