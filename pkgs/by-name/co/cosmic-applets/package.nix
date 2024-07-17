{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  util-linuxMinimal,
  dbus,
  glib,
  libxkbcommon,
  pulseaudio,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "21fc43e5781a7fbe7e7f39a0b68963dc8c2d486d";
    hash = "sha256-WOUlYIh4a8qQhga4weKcuJYxNL5fa4FzNFuRB1T32oU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "cosmic-client-toolkit-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "cosmic-config-0.1.0" = "sha256-6g/Om3SFLa+3fu2dkifbXbFP3ksXTbsjb6Xu7tDB570=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-eSUyDME39UhoimO/gd2mJDaunCrLNXesO9C69IwtjgM=";
      "cosmic-notifications-config-0.1.0" = "sha256-QsLlm+jxsmc90Jc73qKgi52PVZoSwuGXDXw+iSJTALw=";
      "cosmic-panel-config-0.1.0" = "sha256-uUq+xElZMcG5SWzha9/8COaenycII5aiXmm7sXGgjXE=";
      "cosmic-time-0.3.0" = "sha256-Vx9MrdnAwqDCnA6WgT/cXxs4NDWvAVZ6hv0FXi2A8t4=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-3Dc2fU8xBVUmAs0Q1zEdcdG7vlxpBO+UIlyM/kzGcC4=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    pkg-config
    util-linuxMinimal
  ];
  buildInputs = [
    dbus
    glib
    libxkbcommon
    pulseaudio
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  # Force linking to libwayland-client, which is always dlopen()ed.
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}")
      [
        "-Wl,--push-state,--no-as-needed"
        "-lwayland-client"
        "-Wl,--pop-state"
      ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      qyliss
      nyanbinary
    ];
    platforms = platforms.linux;
  };
}
