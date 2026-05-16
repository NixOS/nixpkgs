{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "converged-security-suite";

  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "9elements";
    repo = "converged-security-suite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y/fSkOvTy2EuLBzVWd/U4wSnnCQrHsDr2G8Wf4EzmTk=";
  };

  vendorHash = "sha256-KAtkvlldLb+1vVcec3Q34UNxu1Kj/37bjy8yjPoP5NM=";

  subPackages = [
    "cmd/core/bg-prov"
    "cmd/core/bg-suite"
    "cmd/core/txt-prov"
    "cmd/core/txt-suite"
    "cmd/exp/amd-suite"
    "cmd/exp/pcr0tool"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  checkPhase = ''
    go test -v ./pkg/...
  '';

  meta = {
    homepage = "https://github.com/9elements/converged-security-suite";
    changelog = "https://github.com/9elements/converged-security-suite/releases/tag/v${finalAttrs.version}";
    description = "Converged Security Suite for Intel & AMD platform security features";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    mainProgram = "bg-prov";
  };
})
