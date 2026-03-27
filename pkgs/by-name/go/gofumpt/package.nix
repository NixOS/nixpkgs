{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gofumpt";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "gofumpt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ngqg8YJHqW08hvZp+E+RLLjGArOZJov7/xKCMAWFI1E=";
  };

  vendorHash = "sha256-qCXpFxTZIhDDvvwytvftBnMwOHopO6/FkBWcLZhBDp8=";

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
