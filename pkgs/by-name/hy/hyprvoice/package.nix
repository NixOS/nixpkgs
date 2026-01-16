{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pipewire,
  wl-clipboard,
  wtype,
  ydotool,
  libnotify,
}:
buildGoModule rec {
  pname = "hyprvoice";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "LeonardoTrapani";
    repo = "hyprvoice";
    rev = "v${version}";
    hash = "sha256-mQZ06Go0p9ZeXci6bJCwCiJCkQkcmIcBp2UDb4y33to=";
  };

  vendorHash = "sha256-qYZGccprn+pRbpVeO1qzSOb8yz/j/jdzPMxFyIB9BNA=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/hyprvoice \
      --prefix PATH : ${
        lib.makeBinPath [
          pipewire
          wl-clipboard
          wtype
          ydotool
          libnotify
        ]
      }
  '';

  meta = {
    description = "Voice-powered typing for Hyprland/Wayland";
    longDescription = ''
      Press a toggle key, speak, and get instant text input.
      Built natively for Wayland/Hyprland - no X11 hacks or workarounds,
      just clean integration with modern Linux desktops.
    '';
    homepage = "https://github.com/LeonardoTrapani/hyprvoice";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hyprvoice";
    maintainers = with lib.maintainers; [ metehanyurtseven ];
  };
}
