{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkip";
  version = "0.53.3";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "checkip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F+0qZxtITS4RqeB8s0pTLKckSdaOPYP+AGu58Fh50tg=";
  };

  vendorHash = "sha256-5sUBrzo6wJfaMMvgNflcjB2QNSIeaD2TN7qBao53NFs=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkip";
  };
})
