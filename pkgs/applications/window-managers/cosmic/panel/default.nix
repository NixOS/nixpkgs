{ lib, stdenv, fetchFromGitHub, rust, cargo, just, pkg-config, rustPlatform
, libglvnd, libxkbcommon, wayland
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "unstable-2023-08-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "edfd24ed3b712de397057906924e4f7e8b6252c4";
    hash = "sha256-H3QuiP7Og69wm9yCX/uoSG0aQ3B/61q9Sdj+rW4KZMU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-config-0.1.0" = "sha256-ENdQkLo4MSH/oe6vFr8qByWehch0nMngBr9/6hF7iVk=";
      "cosmic-notifications-util-0.1.0" = "sha256-KnPQdrMpzA05v4bt0Fz9fbcKdC0cSU60Hv7wqrthIaw=";
      "directories-4.0.1" = "sha256-4M8WstNq5I7UduIUZI9q1R9oazp7MDBRBRBHZv6iGWI=";
      "launch-pad-0.1.0" = "sha256-gFtUtrD/cUVpLxPvg6iLxxAK97LTlvI4uLxo06UYIU4=";
      "smithay-0.3.0" = "sha256-qjnpDRzRL0FZ+QYjtD5JeITIY+sfY/yqETNtVT88Ge0=";
      "smithay-client-toolkit-0.17.0" = "sha256-v3FxzDypxSfbEU50+oDoqrGWPm+S+kDZQq//3Q4DDRU=";
      "xdg-shell-wrapper-0.1.0" = "sha256-Otxp8D5dNZl70K1ZIBswGj6K5soGVbVim7gutUHkBvw=";
    };
  };

  nativeBuildInputs = [ cargo just pkg-config ];
  buildInputs = [ libglvnd libxkbcommon wayland ];

  justFlags = [ "--set" "prefix" (placeholder "out") ];
  dontUseJustBuild = 1;  # we need to let cargo-setup-hook do this; it knows the correct flags

  # Force linking to libEGL, which is always dlopen()ed.
  "CARGO_TARGET_${rust.lib.toRustTargetForUseInEnvVars stdenv.hostPlatform}_RUSTFLAGS" = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-Wl,--pop-state"
  ];

  # upstream justfile `install` target does not understand non-native compilation
  preInstall = lib.optionalString (rust.lib.toRustTarget stdenv.buildPlatform != rust.lib.toRustTarget stdenv.hostPlatform) ''
    rm -rf target/release
    mv target/${rust.lib.toRustTarget stdenv.hostPlatform}/release target/release
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
