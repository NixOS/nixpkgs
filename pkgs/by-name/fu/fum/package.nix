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
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-J6XF7/HOPc4nBTomSNT2oG1l8/jAXdrgpvV9b7XaAXc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hgMH8THPJv8RhNkMeQzMcKJG2BJ7KccYwdbyWeJlEJc=";

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
