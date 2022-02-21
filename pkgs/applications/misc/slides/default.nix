{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "slides";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "sha256-05geDWZSpFjLywuWkI+FPaTaO9dyNuPuMBk7dc1Yl6I=";
  };

  checkInputs = [
    bash
    go
  ];

  vendorSha256 = "sha256-i+bbSwiH7TD+huxpTREThxnPkQZTMQJO7AP4kTlCseo=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Terminal based presentation tool";
    homepage = "https://github.com/maaslalani/slides";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
