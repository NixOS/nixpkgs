{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bluetuith";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "bluetuith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yXH/koNT4ec/SOZhSU01iPNAfD1MdMjM2+wNmjXWsrk=";
  };

  vendorHash = "sha256-tEVzuhE0Di7edGa5eJHLLqOecCuoj02h91TsZiZU1PM=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
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
