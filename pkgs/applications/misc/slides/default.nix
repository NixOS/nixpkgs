{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "slides";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "02zdgn0pnjqharvmn9rww45yrja8dzww64s3fryxx4pm8g5km9nf";
  };

  checkInputs = [
    bash
    go
  ];

  vendorSha256 = "11gxr22a24icryvglx9pjmqn5bjy8adfhh1nmjnd21nvy0nh4im7";

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
