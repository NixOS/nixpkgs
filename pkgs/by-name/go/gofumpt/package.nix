{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gofumpt";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "gofumpt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2JahPQQfiYfctMi7AqNB9Y1dS1Pg8usLtzM2wSlC5E0=";
  };

  vendorHash = "sha256-ziqhBWkfWQ0T+gLFqv352PtNcpyCTRFHBfV6iilVGLs=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  checkFlags = [
    # Requires network access (Error: module lookup disabled by GOPROXY=off).
    "-skip=^TestScript/diagnose$"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    changelog = "https://github.com/mvdan/gofumpt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      rvolosatovs
      katexochen
    ];
    mainProgram = "gofumpt";
  };
})
