{
  buildPackages,
  clippy,
  dbus,
  lib,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "switch-to-configuration";
  version = "0.1.0";

  src = ./src;

  cargoLock.lockFile = ./src/Cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  env.SYSTEMD_DBUS_INTERFACE_DIR = "${buildPackages.systemd}/share/dbus-1/interfaces";

  nativeCheckInputs = [
    clippy
  ];

  preCheck = ''
    echo "Running clippy..."
    cargo clippy -- -Dwarnings
  '';

  meta = {
    description = "NixOS switch-to-configuration program";
    mainProgram = "switch-to-configuration";
    maintainers = with lib.maintainers; [ jmbaur ];
    license = lib.licenses.mit;
  };
}
