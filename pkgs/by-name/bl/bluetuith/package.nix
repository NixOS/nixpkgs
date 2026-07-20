{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bluetuith";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "bluetuith-org";
    repo = "bluetuith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FoFmkc6/sPxssEkWHgwM+jtvwJzpDsTJ4T3dzYcxcVc=";
  };

  vendorHash = "sha256-38yPy0dhZ99smFQK0tvQLHah+Sn6DsXvNrh8nQaR5qk=";

  subPackages = [ "." ];

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
    homepage = "https://github.com/bluetuith-org/bluetuith";
    changelog = "https://github.com/bluetuith-org/bluetuith/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "bluetuith";
    maintainers = with lib.maintainers; [
      katexochen
    ];
  };
})
