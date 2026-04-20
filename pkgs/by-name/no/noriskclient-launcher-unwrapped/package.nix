{
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  fetchYarnDeps,
  glib,
  gtk3,
  libayatana-appindicator,
  lib,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  yarnConfigHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noriskclient-launcher-unwrapped";
  version = "0.6.17";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SihBoCh8QRU0UkgMyjm9fmiq+9GuUAhpvHC6UOjSkxA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-tRvtYeOUn3xm7dhLWnzlpS8SK8NVVQAtNgvyiM48X28=";
  };

  patches = [
    # The tauri.conf.json is configured to build multiple apps. We don't want that here.
    ./disable-bundling.patch

    # Make the launcher find java from PATH, instead of downloading its own, which is not going to work on NixOS.
    ./java-from-path.patch
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoHash = "sha256-mldZg4Y12o6Laf2RJSeLzKCcqBpFesUbHhmxRjT9MDI=";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    desktop-file-utils
    nodejs
    pkg-config
    yarnConfigHook
  ];

  buildInputs = [
    glib
    gtk3
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  postInstall = ''
    desktop-file-edit \
    --set-name "NoRiskClient Launcher" \
    --set-comment "Launcher for NoRiskClient" \
    --set-key="Categories" --set-value="Game" \
    --set-key="Keywords" --set-value="nrc;minecraft;mc;" \
    $out/share/applications/NoRisk\ Launcher.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/NoRiskClient/noriskclient-launcher/blob/v3/changelogs/${finalAttrs.version}.txt";
    description = "Minecraft Launcher for NoRisk Client";
    homepage = "https://norisk.gg";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      An easy way to launch the NoRisk Client, create modpacks,
      manage content for Minecraft, and much more - written in tauri.
    '';
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "noriskclient-launcher-v3";
    platforms = lib.platforms.linux;
  };
})
