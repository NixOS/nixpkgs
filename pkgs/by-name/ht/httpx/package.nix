{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "httpx";
  version = "1.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xhHkdW13XvP86J0Mept/XBWL7szoe1g5KNVrxkyJwNA=";
  };

  vendorHash = "sha256-uLmLSJJMlYF9Vz8GBeOUpm3/UP8ngyGgq7GevMm+Tvs=";

  subPackages = [ "cmd/httpx" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [ "-s" ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

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
