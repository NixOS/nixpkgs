{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nextdns";
  version = "1.46.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-Vutd7sTVAcz7ueJYSDAOe8CUAS5agwHEG1hH8mp8its=";
  };

  vendorHash = "sha256-GOj07+OVvtp+/FiwBZJb/E9P/4wiHJrh0Cx2uO3NbCg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
}
