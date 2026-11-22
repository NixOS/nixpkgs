{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  coreutils,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  libsoup_3,
  lsof,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  pkg-config,
  rustPlatform,
  sdl3,
  webkitgtk_4_1,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
  zstd,
  enableUnfree ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "recomplauncher-unwrapped";
  version = "0.90.0-beta.68";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "elripalda";
    repo = "RecompLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bTlrD9vQP7ukoLUhee5MY4b8Bqo+6iy8MlbwAE6yCmM=";
  };

  patches = [
    # register_all() writes a handler pointing at the store path
    ./skip-deep-link-registration.patch
    # UnRAR source is unfree
    ./make-unrar-optional.patch
  ];

  # tests call /usr/bin/true and /bin/sleep
  # tray icon library is loaded with dlopen
  # ad-hoc signing runs xattr, which isn't in the sandbox
  postPatch = ''
    substituteInPlace src-tauri/src/update_rollback_tests.rs \
      --replace-fail '"/usr/bin/true"' '"${lib.getExe' coreutils "true"}"'
    substituteInPlace tests/appimage-update.test.cjs \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace "$cargoDepsCopy"/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail 'libayatana-appindicator3.so.1' '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src-tauri/tauri.macos.conf.json \
      --replace-fail '"signingIdentity": "-"' '"signingIdentity": null'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    sdl3
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    libayatana-appindicator
    libsoup_3
    webkitgtk_4_1
  ];

  cargoHash = "sha256-Aa0FleW/1DQTfclQBO+tLruX6H6r4qCf30Z2L/ABfPs=";

  # gamefiles test runs lsof on macOS
  nativeCheckInputs = [
    nodejs
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ lsof ];

  # copies /bin/sleep, a multi-call symlink on Nix
  # test fixture only has x64 Linux builds
  # hdiutil isn't in the Darwin sandbox
  # /etc can't be resolved in the Darwin sandbox
  checkFlags = [
    "--skip=tests::a_game_that_hands_off_keeps_counting_while_its_folder_runs"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    "--skip=tests::the_badge_check_and_updates_tab_share_one_rule"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=install::mac_archive_tests::a_disk_image_installs_its_app_and_leaves_the_applications_shortcut"
    "--skip=install::tests::links_that_point_nowhere_are_dropped"
  ];

  postCheck = ''
    node --test tests/*.test.cjs
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 src-tauri/icons/icon.png $out/share/icons/hicolor/512x512/apps/recomplauncher.png
    install -Dm644 src-tauri/icons/icon.svg $out/share/icons/hicolor/scalable/apps/recomplauncher.svg
  '';

  # notify-rust names notifications after the executable file
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/libexec
    mv $out/bin/recomplauncher $out/libexec/recomplauncher
    makeWrapper $out/libexec/recomplauncher $out/bin/recomplauncher "''${gappsWrapperArgs[@]}"
  '';

  __darwinAllowLocalNetworking = true;
  buildAndTestSubdir = finalAttrs.cargoRoot;
  buildFeatures = lib.optionals enableUnfree [ "unrar" ];
  # link nixpkgs sdl3 instead of the vendored static build
  cargoPatches = [ ./use-system-sdl3.patch ];
  cargoRoot = "src-tauri";
  checkType = "debug";
  dontWrapGApps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version=unstable"
    ];
  };

  meta = {
    description = "Launcher to find, install, update and play recompiled and decompiled PC games";
    homepage = "https://recomplauncher.com";
    changelog = "https://github.com/elripalda/RecompLauncher/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      if enableUnfree then
        AND [
          gpl3Plus
          unfreeRedistributable
        ]
      else
        gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    mainProgram = "recomplauncher";
  };
})
