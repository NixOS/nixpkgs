{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.124.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-3VrmFSE5YdZYxcEoWtEgonQz7ZERLfF12zcPExNToVs=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-d/ddvixerg30JZtQGNWycUR93Qeaha89W8unKUFPkDg=";

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
