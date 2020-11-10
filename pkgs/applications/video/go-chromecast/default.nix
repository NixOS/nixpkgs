{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y1zwy1bxnjz409vdhqwykvfjhrsyy4j503v3rjrrhkcca6vfbyg";
  };

  vendorSha256 = "04mgm3afgczq0an6ys8bilxv1hgzfwvgjx21fyl82yxd573rsf5r";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
