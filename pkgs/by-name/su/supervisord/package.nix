{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGo127Module (finalAttrs: {
  pname = "supervisord";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "ochinchina";
    repo = "supervisord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l0cbkrX5Mj92IZCEeirySrvyUOvRWNJaC4W0EYBqWP0=";
  };

  __structuredAttrs = true;

  proxyVendor = true;
  vendorHash = "sha256-r1almxcbVR8J49+wtgiT/DE5HUkwUl3PFusAMnjsG3c=";

  preBuild = "go mod tidy";
  subPackages = [ "." ];

  # Currently broken due to version mismatch
  # <https://github.com/ochinchina/supervisord/issues/447>
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/ochinchina/supervisord";
    description = "Process supervisor tool, rewritten from Python in Golang";
    changelog = "https://github.com/ochinchina/supervisord/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "supervisord";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.linux;
  };
})
