{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pop-gtk-theme,
  adw-gtk3,
  pkg-config,
  libpulseaudio,
  pipewire,
  libinput,
  udev,
  openssl,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-settings-daemon";
  version = "1.2.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-cCxcIRrLvCxWDujXuREukkxZ0qPl3SH4n1VWAR1c/QY=";
  };

  postPatch = ''
    substituteInPlace src/battery.rs \
      --replace-fail '/usr/share/sounds/Pop/' '${pop-gtk-theme}/share/sounds/Pop/'
    substituteInPlace src/theme.rs \
      --replace-fail '/usr/share/themes/adw-gtk3' '${adw-gtk3}/share/themes/adw-gtk3'
  '';

  cargoHash = "sha256-rpyMdwmcddsrXuIOI5T6Kh9+cB28DdUxotiqpeGqvCc=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libinput
    libpulseaudio
    openssl
    udev
    pipewire
  ];

  makeFlags = [
    "prefix=$(out)"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    mainProgram = "cosmic-settings-daemon";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
