{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.130.6";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-5IFMIiDP+HmR/yc7OQjs23lO5Cw12lZBsD8oIo2CaLE=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-PnRnnl3uFs889eYQbD+oNvDtJgNepNIJ90KTjnGthI8=";

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
