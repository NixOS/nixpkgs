{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule (finalAttrs: {
  pname = "mtail";
  version = "3.4.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0bUC79nP2MpjbeDMyBe19Li6BqCFegNNPqtuv1DssII=";
  };

  proxyVendor = true;
  vendorHash = "sha256-564euO/Ns7Mju3pFv4wtzxJhblPD3/ThSK62JsZH7VA=";

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
