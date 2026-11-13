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
  version = "0.6.24";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X0j5cWAIMdpLSUSDAUx7oSJ42xvRLL1PY8JK9i4wGhA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-VWl6YqTiBRz85GICFKGwDZRBcITGQdWE7EUzW58wHdY=";
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

  cargoHash = "sha256-dwGJKLO+3i5FUgv+Huu1ZD/hFg/KdyWofApwkIDFD1I=";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  checkFlags = [
    # test fails to find correct function
    "--skip=utils::string_utils::safe_truncate"
  ];

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
