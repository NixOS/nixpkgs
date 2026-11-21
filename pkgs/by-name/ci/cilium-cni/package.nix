{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cilium-cni";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VA9b7KuLlyVsI1gON6oXm0s/JTKED9wHGGJ1cMeOVJI=";
  };

  vendorHash = null;

  subPackages = [ "plugins/cilium-cni" ];

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  tags = [ "osusergo" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cilium/cilium/pkg/version.ciliumVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Cilium CNI plugin";
    homepage = "https://github.com/cilium/cilium";
    changelog = "https://github.com/cilium/cilium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "cilium-cni";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.maxskokov ];
  };
})
