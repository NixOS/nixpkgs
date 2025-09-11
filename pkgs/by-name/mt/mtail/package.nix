{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.2.15";

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-LGfRIjTPt5gwn7yjkoYWj/GbWkMnX+zFPyV3bq85/30=";
  };

  vendorHash = "sha256-w5upL0GAtphsFMm+JlGHNri5PX6hVTw0W9f3wbEL2OA=";

  nativeBuildInputs = [
    gotools # goyacc
  ];

  ldflags = [
    "-X=main.Branch=main"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  # fails on darwin with: write unixgram -> <tmpdir>/rsyncd.log: write: message too long
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # can only be executed under bazel
    "-skip=TestExecMtail"
  ];

  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';

  meta = {
    description = "Tool for extracting metrics from application logs";
    homepage = "https://github.com/jaqx0r/mtail";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "mtail";
  };
}
