{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule (finalAttrs: {
  pname = "mtail";
  version = "3.4.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xjakb+HpctC68FL8ct6aVfwzl0qA2F8sZ3/C1SkFTkY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-/11U9jTTiIZ8ixqWWMt9/ieXhPLT00SJIKViO3m9vsk=";

  nativeBuildInputs = [
    gotools # goyacc
  ];

  ldflags = [
    "-X=main.Branch=main"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.Revision=${finalAttrs.src.rev}"
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
})
