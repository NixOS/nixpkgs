{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-smf";
  version = "1.4.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "smf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-izw+XoSqdP+MpSrzjSZ36FY0bkifaSbWGqXWVB/R7+o=";
  };

  vendorHash = "sha256-bJT3ymL1BV9eEK8q2BmCyGeKB4E0iuJ/ocTSfWmO0mA=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-smf
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/smf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-smf";
  };
})
