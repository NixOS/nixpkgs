{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gat";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    rev = "refs/tags/v${version}";
    hash = "sha256-MBRKp1S/6dizZR0zDyaNGqKsHI+vK6oTNkPuxwbf7os=";
  };

  vendorHash = "sha256-ns1jFmBvIfclb3SBtdg05qNBy18p6VjtEKrahtxJUM4=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${version}"
  ];

  meta = with lib; {
    description = "Cat alternative written in Go";
    license = licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with maintainers; [ themaxmur ];
    mainProgram = "gat";
  };
}
