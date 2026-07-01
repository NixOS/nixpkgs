{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  whisper-cpp,
  pipewire,
  wl-clipboard,
  wtype,
  ydotool,
  libnotify,
  whisperPkg ? whisper-cpp,
}:
buildGoModule (finalAttrs: {
  pname = "hyprvoice";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "LeonardoTrapani";
    repo = "hyprvoice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-geIjm5vChQwO44eSw8E9Tp8d4QkL3IGIdI7Xvpz9Eu8=";
  };

  vendorHash = "sha256-b1IsFlhj+xTQT/4PzL97YjVjjS7TQtcIsbeK3dLOxR4=";

  env.CI = "true";

  nativeCheckInputs = [
    wl-clipboard
    wtype
    ydotool
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion --cmd hyprvoice \
      --bash <($out/bin/hyprvoice completion bash) \
      --zsh <($out/bin/hyprvoice completion zsh) \
      --fish <($out/bin/hyprvoice completion fish)

    wrapProgram $out/bin/hyprvoice \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            pipewire
            wl-clipboard
            wtype
            ydotool
            libnotify
          ]
          ++ lib.optionals (whisperPkg != null) [ whisperPkg ]
        )
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
})
