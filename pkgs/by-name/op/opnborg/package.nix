{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "opnborg";
  version = "0.1.63";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    rev = "v${version}";
    hash = "sha256-t/bcqHsRLE4Mxoe/0pziIHHrPf2ijUkYjr1vq8C1ZzQ=";
  };

  vendorHash = "sha256-kFO4Ju1EbUEc/CZpujmJpM1R1vRI5J4s6UIa2+IhTKE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
