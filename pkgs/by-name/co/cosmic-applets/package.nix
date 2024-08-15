{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, just
, pkg-config
, udev
, util-linuxMinimal
, dbus
, glib
, libinput
, libxkbcommon
, pulseaudio
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "epoch-${version}";
    hash = "sha256-4KaMG7sKaiJDIlP101/6YDHDwKRqJXHdqotNZlPhv8Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-uUpRd8bR2TyD7Y1lpKmJTaTNv9yNsZVnr0oWDQgHD/0=";
      "cosmic-config-0.1.0" = "sha256-FvAxWnwiqsgy643VIDn9PDTC+lg7yZWbWgFihdExBzU=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-notifications-config-0.1.0" = "sha256-VdJ6W8+g2492wAr1kDLo2zWZGc01gHp2dvLVtj/xArE=";
      "cosmic-panel-config-0.1.0" = "sha256-XbyZCOyr0HAkoyjY5Q/IuZgkWVzc3lOfGjGTqvBi1rg=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-A2ZVaTeQ5rwNI3r48cVtC5s7fhnK84rD+p+gaB42MaQ=";
      "cosmic-text-0.12.1" = "sha256-x0XTxzbmtE2d4XCG/Nuq3DzBpz15BbnjRRlirfNJEiU=";
      "cosmic-time-0.4.0" = "sha256-w4yY1fc4r1+pSv93dy/Hu3AD+I1+sozIPbbCoaVQj7w=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ just pkg-config util-linuxMinimal ];
  buildInputs = [ dbus glib libinput libxkbcommon pulseaudio wayland udev ];

  dontUseJustBuild = true;

  justFlags = [
    "--set" "prefix" (placeholder "out")
    "--set" "target" "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  # Force linking to libwayland-client, which is always dlopen()ed.
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lwayland-client"
      "-Wl,--pop-state"
    ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyanbinary ];
    platforms = platforms.linux;
  };
}
