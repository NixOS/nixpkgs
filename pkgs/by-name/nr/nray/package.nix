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
    rev = "refs/tags/v${version}";
    hash = "sha256-N78Bm/Le+pbA8hvDaUbjQpcdRlM0RKXnXyjOB8Nz3AE=";
  };

  vendorHash = "sha256-hCFFMSaT73Wx54KayuFc2xJRGp0p10Pn93N8t4Xad8g=";

  ldflags = [
    "-s"
    "-w"
  ];

  env = {
    CGO_CFLAGS = "-Wno-undef-prefix";
  };

  meta = with lib; {
    description = "Distributed port scanner";
    homepage = "https://github.com/nray-scanner/nray";
    changelog = "https://github.com/nray-scanner/nray/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nray";
    platforms = platforms.linux;
  };
}
