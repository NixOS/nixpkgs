{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XpFE4g5TuO7KqDwKjj8J7h/Nkngh1BGN1bwK8e/1RU0=";
  };

  vendorHash = "sha256-+fq0QAu61U5plFL7I/qTD0NYGeOnK4WfLnpkY9MvNtE=";

  subPackages = [ "cmd/katana" ];

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "katana";
  };
})
