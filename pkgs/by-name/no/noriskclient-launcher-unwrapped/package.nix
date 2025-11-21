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
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9UUNIS8r/695maQ2j2+Wj2L5qy55Wfs/MNhKJnwC6GI=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-IWgP4VEyEBNsxALKGMpk8WZCIc76qcEu5K+kYqsdYkQ=";
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
