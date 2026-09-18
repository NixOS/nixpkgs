{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "stave";
  version = "0.0.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sufield";
    repo = "stave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lq3u5/M9jJl7KLWzu4LRsB1xTn9QjOB4SrlZoF3Ye40=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-X=github.com/sufield/stave/internal/version.Version=v${finalAttrs.version}"
    "-X=github.com/sufield/stave/internal/version.Commit=${finalAttrs.src.rev}"
    "-X=github.com/sufield/stave/internal/version.Date=1970-01-01T00:00:00Z"
    "-X=github.com/sufield/stave/internal/version.BuiltBy=nixpkgs"
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
