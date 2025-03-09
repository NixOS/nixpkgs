{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.119.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-O+DCMgrhlunqetL2GYbNSuSbfcyYNNP3kf9bL6P3uHQ=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-DgW1RCyTDfbc7BiMeMVMWY1gHNdxiLxojAn0NGNeWqA=";

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
