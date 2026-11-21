{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  installShellFiles,
  dbus,
  libpulseaudio,
  notmuch,
  openssl,
  ethtool,
  lm_sensors,
  iw,
  iproute2,
  pandoc,
  pipewire,
  gitMinimal,
  cmake,
  withICUCalendar ? false,
  withPipewire ? true,
  withNotmuch ? false,
  withSpeedtest ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "i3status-rust";
  version = "0.40.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iYSPyL9f/kyVnI0m/9j1GoHbaSJ2LIdfAglI1mLdH5M=";
  };

  cargoHash = "sha256-R3GAQMpF6g8HLPcQBj53n6DXIh8yk4bJx3EFFCf9oJ4=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
    pandoc
    gitMinimal
    cmake
  ]
  ++ (lib.optionals withPipewire [ rustPlatform.bindgenHook ]);

  buildInputs = [
    dbus
    libpulseaudio
    openssl
    lm_sensors
  ]
  ++ (lib.optionals withPipewire [ pipewire ])
  ++ (lib.optionals withNotmuch [ notmuch ]);

  buildFeatures = [
    "maildir"
    "pulseaudio"
  ]
  ++ (lib.optionals withICUCalendar [ "icu_calendar" ])
  ++ (lib.optionals withPipewire [ "pipewire" ])
  ++ (lib.optionals withNotmuch [ "notmuch" ])
  ++ (lib.optionals withSpeedtest [ "speedtest" ]);

  prePatch = ''
    substituteInPlace src/util.rs \
      --replace-fail "/usr/share" "$out/share"
  '';

  postBuild = ''
    cargo xtask generate-manpage
  '';

  postInstall = ''
    mkdir -p $out/share/i3status-rust
    cp -R examples files/* $out/share/i3status-rust
    installManPage man/*
  '';

  postFixup = ''
    wrapProgram $out/bin/i3status-rs --prefix PATH : ${
      lib.makeBinPath [
        iproute2
        ethtool
        iw
      ]
    }
  '';

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = lib.licenses.gpl3Only;
    mainProgram = "i3status-rs";
    maintainers = with lib.maintainers; [
      backuitist
      kybe236
    ];
    platforms = lib.platforms.linux;
  };
})
