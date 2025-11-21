{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.63.1";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    tag = "v${version}";
    hash = "sha256-TwrMrEcs4Aq7PwIDMlCUxC5STMZYfzdCsH3jYKDs68E=";
  };

  vendorHash = "sha256-0eaPJUFgcSY96o3uSL3dd4099axYXymD0ryp1O8fGRQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
