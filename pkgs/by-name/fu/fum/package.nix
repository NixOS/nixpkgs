{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  openssl,
  dbus,
  pkg-config,
  libgcc,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "fum";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-qZGbJGotxJCxlMIRPS/hw/cfz/k8PFdVKoJtqWKXD6s=";
  };

  cargoHash = "sha256-g6Nn3teRHMdlKReX3j0jkhfJEHOigDF4ghSfSYU33o8=";

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    libgcc
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fully ricable tui-based music client";
    homepage = "https://github.com/qxb3/fum";
    changelog = "https://github.com/qxb3/fum/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FKouhai ];
    platforms = lib.platforms.linux;
    mainProgram = "fum";
  };
}
