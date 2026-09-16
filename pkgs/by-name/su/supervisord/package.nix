{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGo127Module (finalAttrs: {
  pname = "supervisord";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "ochinchina";
    repo = "supervisord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2mNAvQJ36aeyMBi37a/hBQOxOWDWA1/LM6dwoi0g1so=";
  };

  __structuredAttrs = true;

  proxyVendor = true;
  vendorHash = "sha256-r1almxcbVR8J49+wtgiT/DE5HUkwUl3PFusAMnjsG3c=";

  preBuild = "go mod tidy";
  subPackages = [ "." ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
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
