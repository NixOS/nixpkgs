{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stayrtr,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "stayrtr";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7/n1rflDgJy2X/PTBTnxuxHMi1Kq/vwQQUepFb11EC0=";
  };
  vendorHash = "sha256-ACfCBbW42tic/m86/pAUquqzK1k05VUtH61mRD4Hu+4=";

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
