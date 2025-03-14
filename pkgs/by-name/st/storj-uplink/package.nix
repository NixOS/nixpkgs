{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.123.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-H62QB/lS3rDUPDJMckRVhChgevyXfQzPBT+XI4/uDNE=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-s6UrM7Kj/w09EXLHeyzcE6YLzucUz/qEpXsghFETRig=";

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
