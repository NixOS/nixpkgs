{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-pagerduty";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "PagerDuty";
    repo = "go-pagerduty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7RBBbe30RQ74DUK/YhBOMyyF5TFfY4WifkPVU070CGU=";
  };

  vendorHash = "sha256-sTCnJfnW/tIn6XlgCfFXRDHv380TDGwGVoB19ADL1WU=";

  subPackages = [ "command" ];

  postInstall = ''
    mv $out/bin/command $out/bin/pd
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI and Go client library for the PagerDuty v2 API";
    homepage = "https://github.com/PagerDuty/go-pagerduty";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ logan-barnett ];
    mainProgram = "pd";
  };
})
