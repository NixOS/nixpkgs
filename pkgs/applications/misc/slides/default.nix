{ lib
, bash
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "slides";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "sha256-K8VsqaNUPxh3/Yddy6DFiOyjRuZ6r6bU456Pm31A1og=";
  };

  nativeCheckInputs = [
    bash
    go
  ];

  vendorHash = "sha256-c3YCf22L5+rTmH5ePeJ0/goRj5rKY6v+Zon3183MhMY=";

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
