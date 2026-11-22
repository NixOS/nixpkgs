{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "stave";
  version = "0.0.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sufield";
    repo = "stave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GL6SCqBKHCWMJx1UsLpXUt9jEJK03FU/C7DwhJ8gM6c=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-X=github.com/sufield/stave/internal/version.String=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    "-skip=TestCapabilities_DefaultVersionFallback"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to find compound attack paths that single-resource scanners miss";
    homepage = "https://github.com/sufield/stave";
    changelog = "https://github.com/sufield/stave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "stave";
  };
})
