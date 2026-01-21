{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    tag = "v${version}";
    hash = "sha256-Ln0VBlaMsNG3Tmfhk86ARqXPT1T3T5zsbWJXs1bOK7s=";
  };

  vendorHash = "sha256-SwlBW7BV+SdAR3H3HOpysfWNFWNqOhhsq3fPr2JSvvA=";

  subPackages = [ "cmd/httpx" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "Fast and multi-purpose HTTP toolkit";
    longDescription = ''
      httpx is a fast and multi-purpose HTTP toolkit allow to run multiple
      probers using retryablehttp library, it is designed to maintain the
      result reliability with increased threads.
    '';
    homepage = "https://github.com/projectdiscovery/httpx";
    changelog = "https://github.com/projectdiscovery/httpx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "httpx";
  };
}
