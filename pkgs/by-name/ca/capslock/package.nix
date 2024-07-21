{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "capslock";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${version}";
    hash = "sha256-mGrq43YCjF137c5ynQxL7IXDCUbnbBLv5E0tw/boObE=";
  };

  vendorHash = "sha256-WTbHcVARbz7cvAY7IZnACTrN5h9NXWXfxxEWq4hssOM=";

  subPackages = [
    "cmd/capslock"
  ];

  CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with maintainers; [ katexochen ];
  };
}
