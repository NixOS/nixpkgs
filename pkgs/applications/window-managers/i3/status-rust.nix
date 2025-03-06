{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  dbus,
  libpulseaudio,
  notmuch,
  openssl,
  ethtool,
  lm_sensors,
  iw,
  iproute2,
  pipewire,
  withICUCalendar ? false,
  withPipewire ? true,
  withNotmuch ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xJm4MsEU0OVX401WvKllg3zUwgCvjLxlAQzXE/oD1J0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EFFmH9aG7DvSA5rsAuszc1B8kcLdruSk3Hhp4V9t9Gk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ] ++ (lib.optionals withPipewire [ rustPlatform.bindgenHook ]);

  buildInputs =
    [
      dbus
      libpulseaudio
      openssl
      lm_sensors
    ]
    ++ (lib.optionals withPipewire [ pipewire ])
    ++ (lib.optionals withNotmuch [ notmuch ]);

  buildFeatures =
    [
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

  postInstall = ''
    mkdir -p $out/share
    cp -R examples files/* $out/share
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

  meta = with lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3Only;
    mainProgram = "i3status-rs";
    maintainers = with maintainers; [
      backuitist
      globin
    ];
    platforms = platforms.linux;
  };
}
