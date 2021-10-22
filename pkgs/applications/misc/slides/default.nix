{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
, python3
, ruby
}:

buildGoModule rec {
  pname = "slides";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "sha256-530OsO3Rg13nmFYOoouhWvy12Afd25O4We9RBHe1CmE=";
  };

  checkInputs = [
    bash
    go
    python3
    ruby
  ];

  vendorSha256 = "sha256-pI5/1LJVP/ZH64Dy2rUoOXM21oqJ8KA0/L8ClGRb5UY=";

  ldflags = [
    "-s" "-w"
    "-X=main.Version=${version}"
  ];

  # https://github.com/maaslalani/slides/issues/113
  doCheck = false;

  meta = with lib; {
    description = "Terminal based presentation tool";
    homepage = "https://github.com/maaslalani/slides";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
