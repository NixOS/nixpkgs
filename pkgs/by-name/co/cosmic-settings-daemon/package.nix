{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  makeBinaryWrapper,
  adw-gtk3,
  pkg-config,
  libpulseaudio,
  pipewire,
  libinput,
  udev,
  libxkbcommon,
  wayland,
  openssl,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-settings-daemon";
  version = "1.9.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-0xacJ7NivwME4w079Tu+Jdm2CTmnSp0cPpviAVs4yQU=";
  };

  postPatch = ''
    substituteInPlace src/theme.rs \
      --replace-fail '/usr/share/themes/adw-gtk3' '${adw-gtk3}/share/themes/adw-gtk3'
  '';

  cargoHash = "sha256-ba3JKWTC5f0DSIILayUFmQQfA3oHaq477AzL3qo3CDE=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libinput
    libpulseaudio
    openssl
    udev
    pipewire
    libxkbcommon
    wayland
  ];

  makeFlags = [
    "prefix=$(out)"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  postFixup = ''
    wrapProgram $out/bin/cosmic-settings-daemon \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
        ]
      }
  '';

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
