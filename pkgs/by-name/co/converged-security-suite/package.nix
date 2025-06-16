{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "converged-security-suite";

  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "9elements";
    repo = "converged-security-suite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/TsKKBrwiwPVyfmDvzouVRyAPLVPsLZFmIIzl0gJWL4=";
  };

  vendorHash = "sha256-p1r6LS0h5NbUdGUHEPtZydXNOjyz7jXegmbFBl38MEI=";

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

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/9elements/converged-security-suite";
    changelog = "https://github.com/9elements/converged-security-suite/releases/tag/v${version}";
    description = "Converged Security Suite for Intel & AMD platform security features";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      felixsinger
    ];
    mainProgram = "bg-prov";
  };
})
