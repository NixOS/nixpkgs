{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gotestwaf";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = "gotestwaf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KQG47T1wd6uaJgm15vRqx1HB1jVNVIEZI90eHMlXMlg=";
  };

  vendorHash = "sha256-tGpgQ1c5mdstq5LX5egmm/ntmjuq2R6eWphsxV5q2b8=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-w"
    "-s"
    "-X=github.com/wallarm/gotestwaf/internal/version.Version=v${finalAttrs.version}"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  meta = {
    description = "Tool for API and OWASP attack simulation";
    homepage = "https://github.com/wallarm/gotestwaf";
    changelog = "https://github.com/wallarm/gotestwaf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gotestwaf";
  };
})
