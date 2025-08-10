{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "grafanactl";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafanactl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+Aj1n0ZU7tW5hTKeTkZQgvlnOBISaYJ2qFramD4eiY=";
  };

  vendorHash = "sha256-eEgGrb/un+KkT7DBJ1SMUUHauZQMYroKo6OBrgzGicM=";

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
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool designed to simplify interaction with Grafana instances";
    homepage = "https://github.com/grafana/grafanactl";
    changelog = "https://github.com/grafana/grafanactl/tags/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wcarlsen ];
    mainProgram = "grafanactl";
  };
})
