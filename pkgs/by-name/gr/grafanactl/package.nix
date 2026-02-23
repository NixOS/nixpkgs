{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "grafanactl";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafanactl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TJoTxVKfG2mfV05pkAxUJR7NKZbD9VIqRW4H8lyP2As=";
  };

  vendorHash = "sha256-zEE4iaZJBneYgo6avCOTG7tWZ88NDskPTYiCMb8pRR4=";

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=unknown"
    "-X main.date=unknown"
  ];

  subPackage = [ "cmd/grafanactl" ];

  postInstall = ''
    rm $out/bin/cmd-reference
    rm $out/bin/config-reference
    rm $out/bin/env-vars-reference
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool designed to simplify interaction with Grafana instances";
    homepage = "https://github.com/grafana/grafanactl";
    changelog = "https://github.com/grafana/grafanactl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wcarlsen ];
    mainProgram = "grafanactl";
  };
})
