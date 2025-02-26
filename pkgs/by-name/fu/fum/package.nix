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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-v/MEqfDMrEVGr2tt3I2R1xPduZSxtiSHDxcp8GBHE+U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1dtCcVtl0ztsrr9LPYgEi51vkAnhdE1HEEvhEOzgLwA=";

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
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
    mainProgram = "fum";
  };
}
