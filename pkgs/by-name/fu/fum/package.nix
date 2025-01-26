{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  stdenv,
  openssl,
  dbus,
  pkg-config,
  libgcc,
}:
rustPlatform.buildRustPackage rec {
  pname = "fum";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-vBn76s2ewLVVYhyXviQUmq+AzH6FSVdJaTEJQ2EPlM0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7h/KIAIxldXPXUo0lzuBqs6Uf5S5p39yV+kTfLe/LBo=";

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

  meta = {
    description = "Fully ricable tui-based music client";
    homepage = "https://github.com/qxb3/fum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
    mainProgram = "fum";
  };
}
