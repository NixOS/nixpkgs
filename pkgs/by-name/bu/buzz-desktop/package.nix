{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  cargo-tauri,
  cmake,
  perl,
  pkg-config,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  gtk3,
  libopus,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  bash,
  git,
  ffmpeg-headless,
  cacert,
  coreutils,
}:

let
  version = "0.5.26-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    rev = "e982f70fba29cdaa9a8378f118a0e498537bd8db";
    hash = "sha256-P64V50KiTBwDmsEZDpF+MDWztpqog+SI6s5wL+b6YtI=";
  };

  workspaceCargoHash = "sha256-9EwiWYHgvjt2l8q/QhgTU9LzNVevS1jwoQA4pZG+GAA=";

  frontend = callPackage ./frontend.nix {
    inherit src;
    version = "0.1.0-unstable-2026-10-03";
  };
  sidecars = callPackage ./sidecars.nix {
    inherit src;
    version = "0.1.0-unstable-2026-10-03";
    cargoHash = workspaceCargoHash;
  };
  sherpaOnnxArchives = callPackage ./sherpa-onnx.nix { };

  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  gstreamerPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-libav
  ];
  gstreamerPluginPath = lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins;

  runtimePrograms = [
    bash
    git
    ffmpeg-headless
  ];
  runtimePath = lib.makeBinPath runtimePrograms;
  caBundle = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  registrySetup = ''
    if [[ -z "''${GST_REGISTRY_1_0:-}" ]]; then
      cacheHome="''${XDG_CACHE_HOME:-''${HOME:?HOME must be set}/.cache}"
      export GST_REGISTRY_1_0="$cacheHome/buzz/gstreamer-1.0/registry-${rustTarget}.bin"
      ${coreutils}/bin/mkdir -p "$cacheHome/buzz/gstreamer-1.0"
    fi
  '';
in
rustPlatform.buildRustPackage {
  pname = "buzz-desktop";
  inherit version src;

  __structuredAttrs = true;

  cargoRoot = "desktop/src-tauri";
  buildAndTestSubdir = "desktop/src-tauri";
  cargoHash = "sha256-GQoRKRv0eM94ckLPBsMWHwA3tPqpThm8ZDv0DL4RUZQ=";
  strictDeps = true;

  postPatch = ''
    rm -rf desktop/dist
    cp -R ${frontend} desktop/dist
    chmod -R u+w desktop/dist

    mkdir -p desktop/src-tauri/binaries
    for executable in \
      buzz \
      buzz-acp \
      buzz-agent \
      buzz-backend-kubernetes \
      buzz-dev-mcp \
      git-credential-nostr
    do
      install -Dm755 \
        "${sidecars}/bin/$executable" \
        "desktop/src-tauri/binaries/$executable-${rustTarget}"
    done

    substituteInPlace desktop/src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "pnpm build"' '"beforeBuildCommand": null'
  '';

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    cargo-tauri.hook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libopus
    libsoup_3
    webkitgtk_4_1
    glib-networking
  ]
  ++ gstreamerPlugins;

  env = {
    AWS_LC_SYS_CMAKE_BUILDER = 1;
    SHERPA_ONNX_ARCHIVE_DIR = sherpaOnnxArchives;
  };

  cargoBuildFlags = [
    "--package"
    "buzz-desktop"
  ];

  doNotPostBuildInstallCargoBinaries = true;
  tauriBuildFlags = [ "--no-sign" ];

  doCheck = false;

  postInstall = ''
    substituteInPlace $out/share/applications/Buzz.desktop \
      --replace-fail 'Categories=' 'Categories=Network;Chat;InstantMessaging;'
    ln -s Buzz.desktop $out/share/applications/buzz-desktop.desktop
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${runtimePath}"
      --set-default SSL_CERT_FILE "${caBundle}"
      --set-default BUZZ_SHELL "${lib.getExe bash}"
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gstreamerPluginPath}"
    )
  '';

  postFixup = ''
    wrapProgramShell "$out/bin/buzz-desktop" \
      --run ${lib.escapeShellArg registrySetup}
  '';

  meta = {
    description = "Desktop client for Buzz, a Nostr-based workspace";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    mainProgram = "buzz-desktop";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
