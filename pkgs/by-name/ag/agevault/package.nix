{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "agevault";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "agevault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lcOrHvRPM+qC5fyXNttvfkooSDcggHg38AuNdewanWE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  vendorHash = "sha256-yt4K+EcoZMJ36E5qolZdbDoeWp1WhVzppVx6nDrFq2s=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/ndavd/agevault";
    changelog = "https://github.com/ndavd/agevault/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ndavd ];
    mainProgram = "agevault";
    description = "Directory encryption tool using age file encryption";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
