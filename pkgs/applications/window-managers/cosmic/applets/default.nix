{ lib, stdenv, fetchFromGitHub, rust, cargo, just, pkg-config, rustPlatform
, dbus, glib, libxkbcommon, pulseaudio, wayland
, unstableGitUpdater
, util-linux
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "29a2dea760d5a3d86ca3226a29065ab3019f689e";
    hash = "sha256-gf8xf/vzVw3yg+LpmOR+z7VJQtEoMEJ+CFO2vgMmFtM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-/6KUCH1CwMHd5YEMOpAdVeAxpjl9JvrzDA4Xnbd1D9k=";
      "cosmic-client-toolkit-0.1.0" = "sha256-pVWK+dODQxNej5jWyb5wX/insoiXkX8NFBDkDEejVV0=";
      "cosmic-config-0.1.0" = "sha256-pUDuRHX46fbcPw19s5DEsPyJdb/Bem/lJg+3NEO/WX0=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-eWqB+zRCfJYdrcPE8Ey+WgzPBJltN0zRiutzgdtWsDA=";
      "cosmic-notifications-config-0.1.0" = "sha256-KnPQdrMpzA05v4bt0Fz9fbcKdC0cSU60Hv7wqrthIaw=";
      "cosmic-panel-config-0.1.0" = "sha256-H3QuiP7Og69wm9yCX/uoSG0aQ3B/61q9Sdj+rW4KZMU=";
      "cosmic-time-0.3.0" = "sha256-JiTwbJSml8azelBr6b3cBvJsuAL1hmHtuHx2TJupEzE=";
      "smithay-client-toolkit-0.17.0" = "sha256-v3FxzDypxSfbEU50+oDoqrGWPm+S+kDZQq//3Q4DDRU=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-Otxp8D5dNZl70K1ZIBswGj6K5soGVbVim7gutUHkBvw=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ cargo just pkg-config util-linux ];
  buildInputs = [ dbus glib libxkbcommon pulseaudio wayland ];

  justFlags = [ "--set" "prefix" (placeholder "out") ];
  dontUseJustBuild = 1;  # we need to let cargo-setup-hook do this; it knows the correct flags

  # Force linking to libwayland-client, which is always dlopen()ed.
  "CARGO_TARGET_${rust.lib.toRustTargetForUseInEnvVars stdenv.hostPlatform}_RUSTFLAGS" = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  # upstream justfile `install` target does not understand non-native compilation
  preInstall = lib.optionalString (rust.lib.toRustTarget stdenv.buildPlatform != rust.lib.toRustTarget stdenv.hostPlatform) ''
    rm -rf target/release
    mv target/${rust.lib.toRustTarget stdenv.hostPlatform}/release target/release
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
