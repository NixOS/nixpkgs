{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  systemd,
  libpulseaudio,
  swaynotificationcenter,
  swaysettings,
  withSwayIntegration ? false,
  nix-update-script,
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

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    systemd
    libpulseaudio
  ]
  ++ lib.optionals withSwayIntegration [
    swaynotificationcenter
    swaysettings
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prevents swayidle from sleeping while any application is outputting or receiving audio";
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    mainProgram = "sway-audio-idle-inhibit";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
