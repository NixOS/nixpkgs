{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "n8n-task-runner-launcher";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "n8n-io";
    repo = "task-runner-launcher";
    tag = finalAttrs.version;
    hash = "sha256-7V//x/AG/3dNWIAQpjBrcOJNn9T9iboKEvJvDV2EK5A=";
  };

  vendorHash = "sha256-5dcIELsNFGB5qTmfpY/YRWeN2z9GdanysGw4Lqpfsi0=";

  postInstall = ''
    mv $out/bin/launcher $out/bin/n8n-task-runner-launcher
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Launcher for n8n task runners";
    homepage = "https://github.com/n8n-io/task-runner-launcher";
    changelog = "https://github.com/n8n-io/task-runner-launcher/releases/${finalAttrs.version}";
    license = lib.licenses.sustainableUse;
    maintainers = with lib.maintainers; [ sweenu ];
    mainProgram = "n8n-task-runner-launcher";
  };
})
