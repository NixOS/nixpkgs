{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-upf";
  version = "1.2.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "go-upf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MfQbHVEqnoFzUL5FPIE6dQSJxQD7PAZSbAgy/skHs+8=";
  };

  vendorHash = "sha256-VPm0Z67Sm/liIofVm1bI3/HU+lwYtwkg6zMRdZFZTZ8=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-upf
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  checkFlags =
    let
      # Skip tests that require gtp5g kernel module
      # result in: create: operation not permitted or get family: no such file or directory
      skippedTests = [
        "TestGtp5g_CreateRules"
        "TestNewFlowDesc"
        "TestServer"
        "TestWaitRoutineStopped"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/go-upf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-upf";
  };
})
