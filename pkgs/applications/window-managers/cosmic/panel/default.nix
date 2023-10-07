{ lib, stdenv, fetchFromGitHub, cargo, just, pkg-config, rust, rustPlatform
, libglvnd, libxkbcommon, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "unstable-2023-09-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "df55f44f504c1cee9377cb331c1fb9d95ca83967";
    hash = "sha256-qf1ITvP6PPATZ6jvlc0UuCes1UYMseY4Wr57/5xRZPE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-client-toolkit-0.1.0" = "sha256-pVWK+dODQxNej5jWyb5wX/insoiXkX8NFBDkDEejVV0=";
      "cosmic-config-0.1.0" = "sha256-XsFfQzR1gn8Je5lbd6PmSgz/T7XAFTVnR1G6pUY+eX4=";
      "cosmic-notifications-util-0.1.0" = "sha256-wRUPovWJucsrKGhjHXku/4UoZf9ih9+Wpbs0sLN+oCI=";
      "launch-pad-0.1.0" = "sha256-gFtUtrD/cUVpLxPvg6iLxxAK97LTlvI4uLxo06UYIU4=";
      "smithay-0.3.0" = "sha256-hulj6zr4h8A9RElQyrJBy3lvYMd7COe3uDaFMMaWNrM=";
      "smithay-client-toolkit-0.17.0" = "sha256-13fXDYqO/701tzoOk8ujHtzgzzz1N6GGbcHUrsNhQ0U=";
      "xdg-shell-wrapper-0.1.0" = "sha256-VCiDjvcCsb02LMo7UpEROV6lzX2DYf4Ix9zfEDO2pUg=";
    };
  };

  nativeBuildInputs = [ just pkg-config ];
  buildInputs = [ libglvnd libxkbcommon wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set" "prefix" (placeholder "out")
    "--set" "bin-src" "target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-panel"
  ];

  # Force linking to libEGL, which is always dlopen()ed.
  "CARGO_TARGET_${rust.toRustTargetForUseInEnvVars stdenv.hostPlatform}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lEGL"
      "-Wl,--pop-state"
    ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
