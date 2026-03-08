{
  fetchFromGitHub,
  lib,
  libpulseaudio,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  systemdMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sway-audio-idle-inhibit";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AIK/2CPXWie72quzCcofZMQ7OVsggNm2Cq9PBJXKyhw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    systemdMinimal
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prevent swayidle/hypridle from sleeping";
    longDescription = ''
      SwayAudioIdleInhibit prevents swayidle/hypridle from sleeping
      while any application is outputting or receiving audio.

      This requires systemd/elogind inhibit support and only works for
      Pulseaudio/Pipewire Pulse.
    '';
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rafaelrc
      yiyu
    ];
    mainProgram = "sway-audio-idle-inhibit";
  };
})
