{ lib
, stdenv
, fetchFromGitHub
, just
, pkg-config
, rust
, rustPlatform
, libglvnd
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "f07cccbd2dc15ede5aeb7646c61c6f62cb32db0c";
    hash = "sha256-uUq+xElZMcG5SWzha9/8COaenycII5aiXmm7sXGgjXE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-client-toolkit-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "cosmic-config-0.1.0" = "sha256-eynEjV7eTRoOUA1v4Ac0FP2h9KQtIDx32WkY0hR4xig=";
      "cosmic-notifications-util-0.1.0" = "sha256-F1+Y74JdpehRPTANzERwNVE6Q6n5f5HAFtawLQVMFrA=";
      "launch-pad-0.1.0" = "sha256-tnbSJ/GP9GTnLnikJmvb9XrJSgnUnWjadABHF43L1zc=";
      "smithay-0.3.0" = "sha256-OI+wtDeJ/2bJyiTxL+F53j1CWnZ0aH7XjUmM6oN45Ow=";
      "smithay-client-toolkit-0.18.0" = "sha256-GhCZ7Eb6q7SwA+NeHSiHwx/Fnrw3R6Zm5N2meMOJ2/4=";
      "xdg-shell-wrapper-0.1.0" = "sha256-8+RXbYiYeoIGUOsJ7yCc2iYtIGKIwDCzSdq9ISuWxIE=";
    };
  };

  nativeBuildInputs = [ just pkg-config ];
  buildInputs = [ libglvnd libxkbcommon wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set" "prefix" (placeholder "out")
    "--set" "bin-src" "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  # Force linking to libEGL, which is always dlopen()ed.
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lEGL"
      "-Wl,--pop-state"
    ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    mainProgram = "cosmic-panel";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyabinary ];
    platforms = platforms.linux;
  };
}
