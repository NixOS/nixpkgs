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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-0359ThCHM14uSQFNoKWm88Bk3aOxyhkulSvoXcpNJMc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XyMf9v9Pfl+j2E1BnNl8SkDvu/0LZ6av9/dsDc0zA8U=";

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
