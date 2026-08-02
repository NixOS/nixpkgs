{
  lib,
  rustPlatform,
  addDriverRunpath,
  cargo-tauri,
  cef-binary,
  dbus,
  desktop-file-utils,
  fetchFromGitHub,
  fetchPnpmDeps,
  gtk3,
  libGL,
  libpulseaudio,
  libxkbcommon,
  nix-update-script,
  nodejs-slim_24,
  pipewire,
  pkg-config,
  pnpm_10,
  pnpmConfigHook,
  symlinkJoin,
  webkitgtk_4_1,
  writeText,
  xdg-utils,
  libayatana-appindicator,
  wrapGAppsHook3,
}:

# this uses the current default runtime for sable, which is the cef runtime.
# the wry (webkitgtk based) runtime does not have working webrtc yet.
# (July 2026) estimate for webrtc with wry is march 2027 https://blogs.igalia.com/webkit/blog/2026/wip-71/

let
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
  cef = cef-binary.override {
    version = "150.0.14";
    gitRevision = "7c1aa68";
    chromiumVersion = "150.0.7871.129";
    srcHashes = {
      x86_64-linux = "sha256-QO9hPkVcrNB6p8gfQl76qLb3frg/E8wo1HDuuk5h+Y8=";
      aarch64-linux = "sha256-tA4hWg9G/UDQSxXUuDO+IRjvc8Qx1cEdGOtiXg3ktk0=";
    };
  };
  # fake archive.json to prevent automatically downloading CEF here
  # as per https://github.com/tauri-apps/cef-rs/issues/426
  fakeArchiveJson = writeText "archive.json" (
    builtins.toJSON {
      name = cef.src.name;
      sha1 = "";
      type = "minimal";
    }
  );
  cefFlat = symlinkJoin {
    name = "cef-${cef.version}-flat";
    paths = [
      "${cef}/${cef.buildType}"
      "${cef}/Resources"
    ];
    postBuild = ''
      ln -s ${cef}/libcef_dll "$out/"
      ln -s ${fakeArchiveJson} "$out/archive.json"
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "sable-desktop";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v1.21.0";
    hash = "sha256-vYoKNflV4vdJpgYVxYCxAQhvqDh1Qf+7qgIFHxriTTU=";
  };

  # patch to use version-identical binary packages, delete at version 1.21.1
  patches = [ ./sableclient-npm-dist.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-BPUVRre9+SXV0wrZxT0PeHl7YWv6+DmPDjy57gpt8hc=";
  };

  # vite would try to use git to set these otherwise
  env = {
    VITE_BUILD_HASH = "nix";
    VITE_IS_RELEASE_TAG = "true";
    CEF_PATH = "${cefFlat}";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-E38C5pttAidLLRLI3+UPYJqQbBhFsMI1nnYu06gvSF8=";
  cargoDepsName = finalAttrs.pname;

  tauriBuildFlags = "--no-sign";
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "cef"
    "custom-protocol"
  ];

  # prevent writing into the user's home dir
  postPatch = ''
    substituteInPlace src-tauri/src/lib.rs \
      --replace-fail "                use tauri_plugin_deep_link::DeepLinkExt;" "" \
      --replace-fail "                app.deep_link().register_all()?;" ""
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    dbus
    desktop-file-utils
    nodejs-slim
    pkg-config
    pnpm
    pnpmConfigHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    # always needed at least until https://github.com/tauri-apps/tauri/pull/15068 gets merged
    webkitgtk_4_1
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libayatana-appindicator
          libGL
          libpulseaudio
          libxkbcommon
          pipewire
        ]
      }:${addDriverRunpath.driverLink}/lib"
      --suffix VK_ADD_DRIVER_FILES : "${addDriverRunpath.driverLink}/share/vulkan/icd.d"
    )
  '';

  # fix the the desktop file so e.g. oidc redirect still works, despite removing the deeplink plugin
  postFixup = ''
    desktop-file-edit \
      --set-key="Categories" --set-value="Network;InstantMessaging;Chat;" \
      --set-key="Exec" --set-value="sable %u" \
      "$out/share/applications/Sable.desktop"
    ln -s ${cef}/${cef.buildType}/* ${cef}/Resources/* "$out/bin/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An almost stable Matrix client";
    homepage = "https://github.com/SableClient/Sable";
    changelog = "https://github.com/SableClient/Sable/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      fugi
      lunar-seal
      toasteruwu
    ];
    license = [
      lib.licenses.agpl3Only
    ];
    mainProgram = "sable";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
