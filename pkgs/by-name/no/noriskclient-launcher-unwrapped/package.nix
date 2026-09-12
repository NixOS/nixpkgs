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
  version = "0.6.27";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aeO0whwJA6nDO6Sf+11YfuYNTDc1Cd8ET5r/WWfnENo=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-K9FWV3fR71dkF0NII67k6sRiC1plwH6M6Tzvd3AsUbU=";
  };

  patches = [
    # The tauri.conf.json is configured to build multiple apps. We don't want that here.
    ./disable-bundling.patch

    # Make the launcher find java from PATH, instead of downloading its own, which is not going to work on NixOS.
    ./java-from-path.patch
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoHash = "sha256-kDMNKpEmp1qGibDhQh2jE1FNsJsI2QOemBC5CLZ+dKI=";

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

  # Fails to link
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/NoRiskClient/noriskclient-launcher/blob/v3/changelogs/${finalAttrs.version}.md";
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
