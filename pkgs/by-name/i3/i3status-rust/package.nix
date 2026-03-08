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
  withICUCalendar ? false,
  withPipewire ? true,
  withNotmuch ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "i3status-rust";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Eam0MDACJN/a8J1Za7Xwy0Jlv/KGNn4M13C2yaCgLnU=";
  };

  cargoHash = "sha256-ezPB/yTxRMpjpekDxbjbRFR0eRaWixVLdosuOBDjyU8=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
    pandoc
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
  ++ (lib.optionals withNotmuch [ "notmuch" ]);

  prePatch = ''
    substituteInPlace src/util.rs \
      --replace "/usr/share/i3status-rust" "$out/share"
  '';

  postBuild = ''
    cargo xtask generate-manpage
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -R examples files/* $out/share
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
    ];
    platforms = lib.platforms.linux;
  };
})
