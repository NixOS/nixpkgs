{
  lib,
  rustPlatform,
  cargo-tauri,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_4_1,
  openssl,
  dbus,
  libsecret,
  glib-networking,
  nix-update-script,
  pomme-client,
}:
rustPlatform.buildRustPackage rec {
  inherit (pomme-client) version src cargoLock;
  pname = "pomme-launcher";
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    pname = "pomme-launcher";
    inherit version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-j2OuFY7aODaJ2yFhI2xgoedlBq0YTix0L6jGAPLGokE=";
  };
  pnpmRoot = "pomme-launcher";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_10
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    webkitgtk_4_1
    openssl
    dbus
    libsecret
    glib-networking
  ];

  postInstall = ''
    ln -s ${pomme-client}/bin/pomme-client $out/bin/pomme-client
  '';

  buildAndTestSubdir = "pomme-launcher/src-tauri";

  doCheck = true;

  env = {
    RUSTC_BOOTSTRAP = "1";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Launcher for the Pomme Minecraft client";
    homepage = "https://github.com/PommeMC/Client";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    platforms = lib.platforms.linux;
    mainProgram = "pomme-launcher";
  };
}
