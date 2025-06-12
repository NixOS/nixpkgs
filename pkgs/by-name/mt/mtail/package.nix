{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-T81eLshaHqbLj4X0feWJE+VEWItmOxcVCQX04zl3jeA=";
  };

  vendorHash = "sha256-Q3Fj73sQAmZQ9OF5hI0t1iPkY8u189PZ4LlzW34NQx0=";

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
