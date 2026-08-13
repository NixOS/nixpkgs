{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-udm";
  version = "1.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "udm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sxksDLI3xV/vz48F9s3TUga6hORaqRTwIiCzeNS0Ijs=";
  };

  vendorHash = "sha256-dl9rNeh4NurAcTFsca2189ReFdg8e5sMjvVGfe8EMWc=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-udm
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/udm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-udm";
  };
})
