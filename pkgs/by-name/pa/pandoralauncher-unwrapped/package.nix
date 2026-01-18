{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  openssl,
  dbus,
  libxcb,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pandoralauncher-unwrapped";
  version = "2.5.0-unstable-2026-01-17";

  src = fetchFromGitHub {
    owner = "Moulberry";
    repo = "PandoraLauncher";
    rev = "45ada235e6208b9d4d2dd420870a1b04cdc9a99d";
    hash = "sha256-aa98NEB8YEuUiMXvFvrgp9NUo4O0Ef7uaSDK0moHgVc=";
  };

  cargoHash = "sha256-HUxxXDfni/vX0YtuR2eSAyntXU/KEuA5wj9pnIyIRzA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libxkbcommon
    dbus
    libxcb
  ];

  meta = {
    description = "Modern Minecraft launcher that balances ease-of-use with powerful instance management features";
    homepage = "https://pandora.moulberry.com/";
    license = lib.licenses.mit;
    mainProgram = "pandora_launcher";
    maintainers = [ lib.maintainers.ind-e ];
    platforms = lib.platforms.linux;
  };
})
