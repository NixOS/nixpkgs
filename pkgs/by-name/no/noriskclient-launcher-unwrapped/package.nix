{
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  fetchYarnDeps,
  glib,
  gtk3,
  lib,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  yarnConfigHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noriskclient-launcher-unwrapped";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RplgSQCiUq3m1dUTfWA5g3VZJeb3b4QQ2yYUMnX4g14=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-O+bYYmeSKgbf/DpK8DZltdHl9qvekLmjyKkGxQBkkIQ=";
  };

  patches = [
    # The tauri.conf.json is configured to build multiple apps. We don't want that here.
    ./disable-bundling.patch

    # Make the launcher find java from PATH, instead of downloading its own, which is not going to work on NixOS.
    ./java-from-path.patch
  ];

  cargoHash = "sha256-heSUEW7r9Lt26Fu68Jo/7BHW6Qmp8GrRSavukCS+ySk=";

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
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux webkitgtk_4_1;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    desktop-file-edit \
    --set-name "NoRiskClient Launcher" \
    --set-comment "Launcher for NoRiskClient" \
    --set-key="Categories" --set-value="Game" \
    --set-key="Keywords" --set-value="nrc;minecraft;mc;" \
    $out/share/applications/NoRisk\ Launcher.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft Launcher for NoRisk Client";
    homepage = "https://norisk.gg";
    license = lib.licenses.gpl3;
    longDescription = ''
      An easy way to launch the NoRisk Client, create modpacks,
      manage content for Minecraft, and much more - written in tauri.
    '';
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "noriskclient-launcher-v3";
    platforms = lib.platforms.linux;
  };
})
