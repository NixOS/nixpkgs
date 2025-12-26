{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-aWGSn5eeFTfBrAsYj38jcf6Xsrz0X5crjjOe0fNu1Mo=";
  };

  vendorHash = "sha256-C1Nm4czf6F2u/OU4jdRQLTXWKBo3mF0TqypbF1pO8yc=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${version}"
  ];

  meta = {
    description = "Cat alternative written in Go";
    license = lib.licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with lib.maintainers; [ themaxmur ];
    mainProgram = "gat";
  };
}
