{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, dbus
, libpulseaudio
, notmuch
, openssl
, ethtool
, lm_sensors
, iw
, iproute2
, pipewire
, withICUCalendar ? false
, withPipewire ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9lzzjb6tDfgqjAT9mS/cWfC6ucNXoJ8JJwtZ0FZqlDA=";
  };

  cargoHash = "sha256-yeijJl94v+yKMVnU/Fjzapab/nExlvoznrx8Ydz/RvM=";

  nativeBuildInputs = [ pkg-config makeWrapper ]
    ++ (lib.optionals withPipewire [ rustPlatform.bindgenHook ]);

  buildInputs = [ dbus libpulseaudio notmuch openssl lm_sensors ]
    ++ (lib.optionals withPipewire [ pipewire ]);

  buildFeatures = [
    "notmuch"
    "maildir"
    "pulseaudio"
  ] ++ (lib.optionals withICUCalendar [ "icu_calendar" ])
  ++ (lib.optionals withPipewire [ "pipewire" ]);

  prePatch = ''
    substituteInPlace src/util.rs \
      --replace "/usr/share/i3status-rust" "$out/share"
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -R examples files/* $out/share
  '';

  postFixup = ''
    wrapProgram $out/bin/i3status-rs --prefix PATH : ${lib.makeBinPath [ iproute2 ethtool iw ]}
  '';

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3Only;
    mainProgram = "i3status-rs";
    maintainers = with maintainers; [ backuitist globin ];
    platforms = platforms.linux;
  };
}
