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
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "qxb3";
    repo = "fum";
    tag = "v${version}";
    hash = "sha256-E9Z8bs5bdNcXHRJIkzcISIz8R1wnZu8sO6tXQp+5bpQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yrDukkbbXqS2iAdtY4WZS6VkqSbyeBXWkn2Od4+mWLw=";

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
