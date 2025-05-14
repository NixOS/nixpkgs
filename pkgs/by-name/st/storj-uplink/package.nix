{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.127.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-Eu96Qw1ENxZ0EhZuAqicmDFvzvMD1DHvNs0s1dgUZ7U=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-kbaUWzHDHiCVQWxIyaSfPY818NAJR2PhbB/552NkbdM=";

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
