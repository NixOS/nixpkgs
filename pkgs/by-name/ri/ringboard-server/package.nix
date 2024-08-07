{
  lib,
  fetchFromGitHub,

  rustPlatform,

  symlinkJoin,

  pkg-config,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  wayland,
  nix-update-script,
  testers,
  ringboard-server,
  ringboard-cli,
  ringboard-egui,
  ringboard-tui,
  ringboard-wayland,
  ringboard-x11,
}:

# let
#
#   # clients
#   egui = rustPlatform.buildRustPackage {
#     pname = "ringboard-egui";
#     inherit src version;
#
#     cargoHash = "";
#   };
#
#   x11 = rustPlatform.buildRustPackage {
#     pname = "ringboard-x11";
#     inherit src version;
#
#     cargoHash = "";
#   };
#
#   tui = rustPlatform.buildRustPackage {
#     pname = "ringboard-tui";
#     inherit src version;
#
#     cargoHash = "";
#   };
# in

rustPlatform.buildRustPackage rec {
  pname = "ringboard-server";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    rev = "refs/tags/${version}";
    hash = "sha256-rBU365pqGitMAOWhIJi3RUGJYxEh7wOmhC+Re0XUN2M=";
  };

  buildAndTestSubdir = "server";

  # TODO handle installation/exporting of the systemd service file

  cargoHash = "sha256-LdKhNVeHOR9uIScC72acL7g/RKqpaJP5Fx5fyvtagjk=";

  cargoBuildFlags = [
    "--no-default-features"
    "--features=systemd"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = ringboard-server; };
      inherit ringboard-cli ringboard-egui ringboard-tui ringboard-wayland ringboard-x11 ;
    };
  };

  meta = {
    description = "Server component for Rinboard, a clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    changelog = "https://github.com/SUPERCILEX/clipboard-history/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "ringboard"; # TODO: check
  };
}
