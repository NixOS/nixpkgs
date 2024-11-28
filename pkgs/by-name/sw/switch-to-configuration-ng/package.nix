{
  buildPackages,
  dbus,
  lib,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "switch-to-configuration";
  version = "0.1.0";

  src = ./src;

  cargoLock = {
    lockFile = ./src/Cargo.lock;
    outputHashes."rust-ini-0.21.1" = "sha256-0nSBhme/g+mVsYdiq0Ash0ek9WEdvbf/b9FRxA7sauk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  env.SYSTEMD_DBUS_INTERFACE_DIR = "${buildPackages.systemd}/share/dbus-1/interfaces";

  meta = {
    description = "NixOS switch-to-configuration program";
    mainProgram = "switch-to-configuration";
    maintainers = with lib.maintainers; [ jmbaur ];
    license = lib.licenses.mit;
  };
}
