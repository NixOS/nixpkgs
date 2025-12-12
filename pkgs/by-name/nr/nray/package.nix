{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nray";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nray-scanner";
    repo = "nray";
    tag = "v${version}";
    hash = "sha256-N78Bm/Le+pbA8hvDaUbjQpcdRlM0RKXnXyjOB8Nz3AE=";
  };

  vendorHash = "sha256-hCFFMSaT73Wx54KayuFc2xJRGp0p10Pn93N8t4Xad8g=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Distributed port scanner";
    homepage = "https://github.com/nray-scanner/nray";
    changelog = "https://github.com/nray-scanner/nray/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nray";
    platforms = lib.platforms.linux;
  };
}
