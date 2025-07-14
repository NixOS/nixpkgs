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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "overpush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bs5Mlpod7bIQxekadU6xBhgC8nchli+BvxEH6NeMOKw=";
  };

  vendorHash = "sha256-wsuztFwEfluUxL2RjMP7Y+JtxQHr5oLwHkAL8UIHyVQ=";

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
