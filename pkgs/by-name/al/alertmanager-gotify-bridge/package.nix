{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "alertmanager-gotify-bridge";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "alertmanager_gotify_bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jG4SC+go6ZxdV1RtLJjZdL4I8jLayY5JKK8mlMDD2pE=";
  };

  vendorHash = "sha256-EjsfY8Ys0Fd99sx7OsZ2jcstdVloqDQQj5xfoIVSX9E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/alertmanager_gotify_bridge";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bridge between Prometheus AlertManager and a Gotify server";
    homepage = "https://github.com/DRuggeri/alertmanager_gotify_bridge";
    changelog = "https://github.com/DRuggeri/alertmanager_gotify_bridge/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ juli0604 ];
    mainProgram = "alertmanager_gotify_bridge";
  };
})
