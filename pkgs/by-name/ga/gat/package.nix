{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
  version = "0.25.4";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-DRTSI6fCakVjAzGGlisvTkDiIQKXlv3XQ3SfB2UjiC8=";
  };

  vendorHash = "sha256-287u3zjlEOuc45stq7k1v5IINRUASw83sw6Dmqv9aUs=";

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
