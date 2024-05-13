{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "2024.0119.1";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    hash = "sha256-CLmlcuRb5dt1oPNdBfx0ql1Zmn/HahcmhVA0k50i6yA=";
  };

  vendorHash = "sha256-unIyU60IrbiKDIjUf9F2pqqGNIA4gFp5XyQlvx6+xxQ=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  passthru.tests = {
    inherit (nixosTests) endlessh-go;
  };

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "endlessh-go";
  };
}
