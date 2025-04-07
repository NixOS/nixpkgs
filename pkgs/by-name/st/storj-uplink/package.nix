{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.125.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${version}";
    hash = "sha256-r0N9TpSlKkGy/hlVxKB+fMXFvQQOXC5L4Ryd5fP+Ud0=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-OhYxrRTVbAbpPz25g27wgM30AQmQf3Uxh03ax8znFYY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
