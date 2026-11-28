{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  aws-lc,
  glib-networking,
  webkitgtk_4_1,
  curl,
  umu-launcher,
  xz,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blizznux";
  version = "0.2.46";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlizzNux";
    repo = "launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+RmfGmM3QvS+PKKIyrFl0w8h5bQy24FuAY3B3kWixeo=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-DcbdjSAPf95RgDz7B2YYS7eiFMZEY44YY77yYlcDpaI=";

  # The UI is static (ui/), so the Tauri binary is the only build product.
  # `cargo tauri build` would only add this feature and a .deb.
  buildFeatures = [ "tauri/custom-protocol" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    aws-lc
    glib-networking
    webkitgtk_4_1
  ];

  # The app finds `blizznux-run` next to its own binary.
  postInstall = ''
    install -Dm755 bin/blizznux-run -t $out/bin
    install -Dm644 share/applications/com.blizznux.launcher.desktop -t $out/share/applications
    cp -r share/icons $out/share
  '';

  # Upstream downloads a umu-launcher zipapp at runtime, which cannot start
  # its Steam Runtime container on NixOS. Point BLIZZNUX_UMU at nixpkgs'
  # umu-launcher (same release) and put curl/xz on PATH (the upstream deb/rpm
  # dependencies minus python3, which was only needed for the zipapp).
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          xz
        ]
      }
      --set-default BLIZZNUX_UMU ${lib.getExe umu-launcher}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Install and launch Battle.net games through Proton, without Steam";
    homepage = "https://github.com/BlizzNux/launcher";
    changelog = "https://github.com/BlizzNux/launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "blizznux";
    platforms = [ "x86_64-linux" ];
  };
})
