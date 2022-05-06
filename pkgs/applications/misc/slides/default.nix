{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "slides";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "sha256-Ca0/M4B6yAdV4hbJ95gH9MVZg3EFIY5bSMkkYy2+P+Q=";
  };

  checkInputs = [
    bash
    go
  ];

  vendorSha256 = "sha256-pn7c/6RF/GpECQtaxsTau91T7pLg+ZAUBbnR7h8DfnY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Terminal based presentation tool";
    homepage = "https://github.com/maaslalani/slides";
    changelog = "https://github.com/maaslalani/slides/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani penguwin ];
  };
}
