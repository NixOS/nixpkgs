{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1ySOlP0sFk3+IRt/zstZK6lEE2pzoVSiZz3wFxdesgc=";
  };

  env.CGO_ENABLED = 0;

  vendorHash = "sha256-KlouLjW9hVKFi9uz34XHd4CzNOiyO245QNygkB338YQ=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
    mainProgram = "chamber";
  };
}
