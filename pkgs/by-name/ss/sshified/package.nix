{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sshified";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "hoffie";
    repo = "sshified";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vwmBV4w+vNpMqCzumE4OHq02nsoQxZ1BAC2dWS5GC3Q=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Proxy HTTP requests through SSH";
    homepage = "https://github.com/hoffie/sshified";
    changelog = "https://github.com/hoffie/sshified/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ joinemm ];
    mainProgram = "sshified";
  };
})
