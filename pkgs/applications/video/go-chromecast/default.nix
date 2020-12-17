{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0frvj1van1qn7hi96m0l7pzm4jf0v49xl4r4fi2lh1yqzgsgzy9f";
  };

  vendorSha256 = "0vgbmgk07kqmhhmcssy1ibr2hzk07hf32kkdyj2b9jqj9sb49p49";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
