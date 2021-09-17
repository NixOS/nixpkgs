{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8216YaDgjy9Fp94Y5SQwEQpAP4NwvEhsJHe6xpQLAk8=";
  };

  vendorSha256 = "sha256-idxElk4Sy7SE9G1OMRw8YH4o8orBa80qhBXPA+ar620=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
