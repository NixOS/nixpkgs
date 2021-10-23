{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "slides";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "sha256-D2ex9/XN5JMKwn+g1cB77UMquYW9NdTzhCCvVtTOBfU=";
  };

  checkInputs = [
    bash
    go
  ];

  vendorSha256 = "sha256-pI5/1LJVP/ZH64Dy2rUoOXM21oqJ8KA0/L8ClGRb5UY=";

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
