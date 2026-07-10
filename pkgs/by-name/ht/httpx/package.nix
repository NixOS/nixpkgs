{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "httpx";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WVmxXdQUNrWaVgxx9cirafgsW8+wuNsYyCXYV3mvX9E=";
  };

  vendorHash = "sha256-ALC8vhK/vzuKpiE1iQ2u0Orx/fUw5eVz32LyMrdrrrk=";

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
    changelog = "https://github.com/projectdiscovery/httpx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "httpx";
  };
})
