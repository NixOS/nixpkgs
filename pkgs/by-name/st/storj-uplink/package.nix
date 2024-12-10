{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.116.5";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-vQftcQU7WUDfVFKYswtpEHbSyReIcWF83vEQrEbzbHk=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-4wkgQQGbQi9ZcBaExRQysL6r/rJZez9z7keaJReuAeg=";

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
