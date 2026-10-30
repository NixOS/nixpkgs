{
  lib,
  rustPlatform,
  addDriverRunpath,
  cacert,
  cargo-tauri,
  cef-binary,
  dbus,
  desktop-file-utils,
  ffmpeg-headless,
  gtk3,
  libayatana-appindicator,
  libGL,
  libpulseaudio,
  libxkbcommon,
  makeBinaryWrapper,
  nodejs-slim,
  pipewire,
  pkg-config,
  sable-next-unwrapped,
  symlinkJoin,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-utils,
}:

# Like upstream's Linux builds, this uses the CEF (Chromium) runtime.
# The default wry runtime is based on WebKitGTK, which does not support WebRTC yet,
# so voice and video calls would not work.
# As of July 2026, WebRTC support in WebKitGTK is expected around March 2027:
# https://blogs.igalia.com/webkit/blog/2026/wip-71/

let
  cefFlat = symlinkJoin {
    name = "cef-${cef-binary.version}-flat";
    paths = [
      "${cef-binary}/${cef-binary.buildType}"
      "${cef-binary}/Resources"
    ];
    postBuild = ''
      ln -s ${cef-binary}/include "$out/"
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "sable-desktop";
  # the frontend and the rust crates come from sable-next-unwrapped
  inherit (sable-next-unwrapped) version src cargoDeps;

  env.CEF_PATH = "${cefFlat}";

  tauriBuildFlags = [
    "--config"
    (builtins.toJSON {
      build = {
        frontendDist = "${sable-next-unwrapped}";
        beforeBuildCommand = "";
      };
    })
    "--no-sign"
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "cef" ];

  postPatch = ''
    # take over the identity, data and url schemes of sable v1, like upstream's stable builds
    node scripts/ci/prepare-v1-release.mjs

    # cef-rs refuses a newer cef than the one it was generated for, but cef keeps
    # older api versions working, so it can use the cef from nixpkgs instead of a pinned one
    substituteInPlace $cargoDepsCopy/*/cef-dll-sys-*/build.rs \
      --replace-fail \
        'download_cef::check_archive_json(&package_version, &path.to_string_lossy())?;' \
        ""

    # prevent writing into the user's home dir
    substituteInPlace src-tauri/src/lib.rs \
      --replace-fail "        use tauri_plugin_deep_link::DeepLinkExt;" "" \
      --replace-fail "        app.deep_link().register_all()?;" ""
  '';

  # the tests build http clients, which need the system ca certificates
  nativeCheckInputs = [ cacert ];

  checkFlags = [
    # expects the development url scheme, which prepare-v1-release.mjs replaces
    "--skip=deep_link_ipc::tests::keeps_only_the_deep_links_after_argv_zero"
    # flaky: builds the membership twice and compares them, but its expiry is taken
    # from the current time, so they differ when a millisecond passes in between
    "--skip=calls::runtime::tests::a_screen_share_flag_is_top_level_and_leaves_the_membership_untouched"
    # fails on 2.2.2: the first event is no longer the pagination status it expects
    "--skip=sdk_timeline_tests::live_timeline_reports_its_back_pagination_status"
  ];

  nativeBuildInputs = [
    cargo-tauri.hook
    desktop-file-utils
    makeBinaryWrapper
    nodejs-slim
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    gtk3
    # the tauri bundler looks for it at build time, the tray icon loads it at runtime
    libayatana-appindicator
    pipewire
    # only needed at build time: tauri-runtime depends on webkit2gtk on linux even with the cef runtime,
    # until https://github.com/tauri-apps/tauri/pull/15985 lands in a tauri release
    webkitgtk_4_1
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          ffmpeg-headless
          xdg-utils
        ]
      }"
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libayatana-appindicator
          libGL
          libpulseaudio
          libxkbcommon
        ]
      }:${addDriverRunpath.driverLink}/lib"
      --suffix VK_ADD_DRIVER_FILES : "${addDriverRunpath.driverLink}/share/vulkan/icd.d"
    )
  '';

  # wrapped by hand below, so that only the launcher ends up in bin
  dontWrapGApps = true;

  postFixup = ''
    # cef needs its libraries and resources beside the executable,
    # libexec keeps its helper binaries off PATH
    mkdir -p "$out/libexec/sable"
    mv "$out/bin/sable" "$out/libexec/sable/"
    ln -s ${cef-binary}/${cef-binary.buildType}/* ${cef-binary}/Resources/* "$out/libexec/sable/"
    makeBinaryWrapper "$out/libexec/sable/sable" "$out/bin/sable" "''${gappsWrapperArgs[@]}"

    # the oauth login comes back through the url schemes, which needs %u
    desktop-file-edit \
      --set-key="Categories" --set-value="Network;InstantMessaging;Chat;" \
      --set-key="Exec" --set-value="sable %u" \
      "$out/share/applications/Sable.desktop"
  '';

  meta = {
    description = "Desktop client for Sable, a Matrix client";
    inherit (sable-next-unwrapped.meta) homepage changelog license;
    maintainers = with lib.maintainers; [
      fugi
      LashaKamadadze
      toasteruwu
    ];
    sourceProvenance =
      sable-next-unwrapped.meta.sourceProvenance
      # the prebuilt cef libraries linked into libexec
      ++ [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "sable";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
