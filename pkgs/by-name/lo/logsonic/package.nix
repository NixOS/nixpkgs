{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "logsonic";
  version = "1.4.0";

  __structuredAttrs = true;

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "logsonic";
    repo = "logsonic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2BFmXxEVPdojH2p0dwijFk4vLFBEp8QWvB/WssBHFlk=";
  };

  frontend = callPackage ./frontend.nix {
    inherit (finalAttrs) version src;
  };

  modRoot = "backend";

  vendorHash = "sha256-E5lJcYBHeAWr4V+zyDQSn4N7tpNcvtQyRwft+n+42yY=";

  preBuild = ''
    mkdir -p pkg/static
    cp -r ${finalAttrs.frontend}/dist pkg/static/
  '';

  passthru = {
    inherit (finalAttrs) frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Desktop-first log analytics application";
    homepage = "https://github.com/logsonic/logsonic";
    changelog = "https://github.com/logsonic/logsonic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "logsonic";
    maintainers = with lib.maintainers; [ mschuwalow ];
    platforms = lib.platforms.unix;
  };
})
