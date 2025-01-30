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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-KOxT7h7HcI3AsWKTV7BjJeVCkzReMHu3Xl6oGD+JjJw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-le+aGSUQos1jgo/9K3wWjVBMcgvBH4dZOaw7wor2sMs=";

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
