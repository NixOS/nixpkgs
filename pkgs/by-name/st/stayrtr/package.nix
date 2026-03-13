{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stayrtr,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "stayrtr";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QdPp+AHOVn/L4lArhwUNNu3OP2ALEFzs/hVnfSxaEbg=";
  };
  vendorHash = "sha256-m1CHpmTUQVkBjkjg2bjl9llU1Le1GLRKKLGT4h7MbnE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = stayrtr;
  };

  meta = {
    changelog = "https://github.com/bgp/stayrtr/releases/tag/v${finalAttrs.version}";
    description = "RPKI-To-Router server implementation in Go";
    homepage = "https://github.com/bgp/stayrtr/";
    license = lib.licenses.bsd3;
    mainProgram = "stayrtr";
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
})
