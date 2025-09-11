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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-VRcQWwO80xFn5A21yjRsGqnnWkhWfsJxxEiw78NWJPM=";
  };

  cargoHash = "sha256-GW3/SqQlEUTMtvOgnMGhcREOHz/V2qtjtCAzFFKMNb4=";

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
