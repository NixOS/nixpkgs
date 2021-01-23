{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OCykgy49RZL2aAE0OeHxj8zkFnr32sIYjtoFMwESqLg=";
  };

  vendorSha256 = "sha256-idxElk4Sy7SE9G1OMRw8YH4o8orBa80qhBXPA+ar620=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
