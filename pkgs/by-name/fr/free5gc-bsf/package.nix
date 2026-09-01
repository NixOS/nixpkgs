{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-bsf";
  version = "1.0.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "bsf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W96T31iIGEuQqaTNqEtMxviPd054bpDNMXyfF+JlCb0=";
  };

  vendorHash = "sha256-Xj3cwrAwtTM62SvLZ0Dq7KCBYdPRXuRPOo7+917+Rzk=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-bsf
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/bsf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-bsf";
  };
})
