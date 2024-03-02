{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KeIhul6xeak2UR+MadKC2j1uHiPwdsh5bjGr1uvOL/4=";
  };

  vendorHash = "sha256-XthLmfHmkTsI4l5Sz5P1qeuxamVTLX7i+Wf73n7iv1M=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/darkhz/bluetuith/cmd.Version=${version}@nixpkgs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    longDescription = ''
      Bluetuith can transfer files via OBEX, perform authenticated pairing,
      and (dis)connect different bluetooth devices. It interacts with bluetooth
      adapters and can toogle their power and discovery state. Bluetuith can also
      manage Bluetooth-based networking/tethering (PANU/DUN) and remote control
      devices. The TUI has mouse support.
    '';
    homepage = "https://github.com/darkhz/bluetuith";
    changelog = "https://github.com/darkhz/bluetuith/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "bluetuith";
    maintainers = with maintainers; [ thehedgeh0g katexochen ];
  };
}
