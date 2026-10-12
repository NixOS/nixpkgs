{
  lib,
  rustPlatform,
  addDriverRunpath,
  binaryen,
  cacert,
  cargo-tauri,
  cef-binary,
  dbus,
  desktop-file-utils,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchurl,
  ffmpeg-headless,
  gtk3,
  libayatana-appindicator,
  libGL,
  libpulseaudio,
  libxkbcommon,
  lld,
  makeBinaryWrapper,
  nodejs-slim_24,
  pipewire,
  pkg-config,
  pnpm_12,
  pnpmConfigHook,
  symlinkJoin,
  wasm-bindgen-cli_0_2_129,
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
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_12.override { inherit nodejs-slim; };
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
  # the noise suppression assets the frontend build would download, see scripts/fetch-deepfilternet.mjs
  deepfilternet = {
    "v3/pkg/df_bg.wasm" = fetchurl {
      url = "https://cdn.mezon.ai/AI/models/datas/noise_suppression/deepfilternet3/v3/pkg/df_bg.wasm";
      hash = "sha256-RAtdErbqfZUAhzb4RCIdeHTuFd5csQ0wFQAkcP26BDI=";
    };
    "v3/models/DeepFilterNet3_onnx.tar.gz" = fetchurl {
      url = "https://github.com/Rikorose/DeepFilterNet/raw/84d57ec2c08fe08e68a13fb32a58cd7092060a0f/models/DeepFilterNet3_onnx.tar.gz";
      hash = "sha256-yU2R9wkRAByUbg+rtKqa3DcEX0WgO1YAjLDIJEy2NhY=";
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "sable-desktop";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "sable-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GgX9EQOMn80X35wLpsZF96TF4tUHadWYoFDzBcGKdA4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-9B/DLEI6oCjrvdfp+U4HSBZnLCcIhoBU4Jkpa0MnqHk=";
  };

  env = {
    VITE_APP_VERSION = finalAttrs.version;
    SABLE_BUILD_FLAVOR = "stable";
    CEF_PATH = "${cefFlat}";
  };

  cargoHash = "sha256-TLz9XwQOn/DRZa+OILYYvh+xMrTYLcrB1vfdXJJUjcQ=";
  cargoDepsName = finalAttrs.pname;

  tauriBuildFlags = [
    "--config"
    "src-tauri/tauri.ci.conf.json"
    "--no-sign"
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "cef" ];

  postPatch = ''
    # take over the identity, data and url schemes of sable v1, like upstream's stable builds
    node scripts/ci/prepare-v1-release.mjs

    ${lib.concatMapAttrsStringSep "\n" (path: asset: ''
      install -Dm644 ${asset} static/deepfilternet3/${path}
    '') deepfilternet}

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
  ];

  # the tauri ci config skips beforeBuildCommand, which would go through mise
  preBuild = ''
    node scripts/build-wasm.mjs --release
    pnpm exec vite build
  '';

  nativeBuildInputs = [
    binaryen
    cargo-tauri.hook
    desktop-file-utils
    lld
    makeBinaryWrapper
    nodejs-slim
    pkg-config
    pnpm
    pnpmConfigHook
    rustPlatform.bindgenHook
    wasm-bindgen-cli_0_2_129
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Matrix client";
    homepage = "https://github.com/SableClient/sable-next";
    changelog = "https://github.com/SableClient/sable-next/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      fugi
      LashaKamadadze
      toasteruwu
    ];
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # the prebuilt deepfilternet wasm module
      binaryBytecode
      # the prebuilt cef libraries linked into libexec
      binaryNativeCode
    ];
    mainProgram = "sable";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
