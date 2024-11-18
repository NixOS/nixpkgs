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

  useFetchCargoVendor = true;
  cargoHash = "sha256-1IQ9WU87fe9771dznIKKMn4jjFTKZfJY5xISTA2myp8=";

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
