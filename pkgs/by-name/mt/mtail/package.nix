{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.2.26";

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-L+kRRAP74n8OJVQhbDjDGNc8IYp/11a6sKbGa1/UdNY=";
  };

  vendorHash = "sha256-kdPj9XjjvDMNCP8K8RBFoHCd1G2NqVq6UR1XykZEdkQ=";

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
