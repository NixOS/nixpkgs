{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "nhost-cli";
  version = "1.52.0";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "nhost";
    tag = "cli@${finalAttrs.version}";
    hash = "sha256-QcUvPtByLlMbxoR6HqxsEmyETXnlyiAg7ukyya4IdAA=";
  };

  subPackages = [ "cli" ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-X=main.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool for setting up a local development environment for Nhost";
    homepage = "https://github.com/nhost/cli";
    changelog = "https://github.com/nhost/nhost/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nhost";
  };
})
