{
  lib,
  # Module requires Go 1.25, drop pin once buildGoModule uses Go >= 1.25.
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "bluetuith";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "bluetuith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h7SMGI8wIiu4i2kcKRsmLHM4tu7ZZK0usBXh5zFu94E=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/darkhz/bluetuith/cmd.Version=${finalAttrs.version}@nixpkgs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI-based bluetooth connection manager";
    longDescription = ''
      Bluetuith can transfer files via OBEX, perform authenticated pairing,
      and (dis)connect different bluetooth devices. It interacts with bluetooth
      adapters and can toogle their power and discovery state. Bluetuith can also
      manage Bluetooth-based networking/tethering (PANU/DUN) and remote control
      devices. The TUI has mouse support.
    '';
    homepage = "https://github.com/darkhz/bluetuith";
    changelog = "https://github.com/darkhz/bluetuith/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "bluetuith";
    maintainers = with lib.maintainers; [
      pyrox0
      katexochen
    ];
  };
})
