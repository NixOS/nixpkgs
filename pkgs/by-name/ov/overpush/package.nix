{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "overpush";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "overpush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I4i1HhqvliSFiL8rFhKF5qrfPsUuxDTE79V/Q7Js+xs=";
  };

  vendorHash = "sha256-2KUWWATRwwtA/1Nm2JQrDS8f0ZIca/f190DSNtjemZE=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted, drop-in replacement for Pushover that can use XMPP";
    homepage = "https://github.com/mrusme/overpush";
    changelog = "https://github.com/mrusme/overpush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "overpush";
  };
})
