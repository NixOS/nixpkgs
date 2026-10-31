{
  lib,
  stdenv,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  alsa-lib,
  bun,
  cargo-tauri,
  desktop-file-utils,
  glib-networking,
  gtk3,
  libgbm,
  libglvnd,
  libpulseaudio,
  libsoup_3,
  libx11,
  libxcursor,
  libxi,
  libxinerama,
  libxrandr,
  libxxf86vm,
  makeWrapper,
  mesa,
  nodejs,
  openssl,
  pipewire,
  pkg-config,
  wayland,
  webkitgtk_4_1,
  writableTmpDirAsHomeHook,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cubiclauncher";
  version = "36.0.0";

  src = fetchFromGitHub {
    owner = "CubicLauncherDevs";
    repo = "CubicLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WhWM0eEY36GfmD/EFlPzrXxNxSuxspweu1gQwumjZiI=";
  };

  cargoHash = "sha256-7HByN/N9XaWt06vhEkwc3JslfMY3as68PJbBfWMEba4=";

  __structuredAttrs = true;

  # Bun's lockfile has no npm-compatible lockfile, so vendor node_modules in a
  # fixed-output derivation. Keep per-platform hashes for optional native deps.
  nodeModules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node-modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      bun install --frozen-lockfile --allow-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r node_modules "$out/node_modules"
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash =
      {
        x86_64-linux = "sha256-iznqcE94oIL7yM8FqX9fO6OHdmR1j8splPOi4fQ3sNI=";
        aarch64-linux = "sha256-GrQ4QZ0bcrDL4kvapQdfxmMMTCjJvuvC31o7tPBwk/8=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  };

  postPatch = ''
    cp -r ${finalAttrs.nodeModules}/node_modules .
    chmod -R +w node_modules
    patchShebangs --build node_modules

    # Nix manages application updates, so updater artifacts are not needed.
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' \
                  '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    bun
    cargo-tauri.hook
    makeWrapper
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gtk3
    libsoup_3
    webkitgtk_4_1
  ];

  # OpenAL and GLFW load these libraries dynamically at runtime.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        alsa-lib
        libpulseaudio
        pipewire
        libx11
        libxcursor
        libxi
        libxinerama
        libxrandr
        libxxf86vm
      ]
    }")
  '';

  # wrapGAppsHook4 creates a C wrapper; put a shell wrapper around it for EGL
  # selection and NVIDIA/Wayland WebKit workarounds.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv "$out/bin/cubiclauncher" "$out/bin/.cubiclauncher-gtk-wrapped"
    makeShellWrapper "$out/bin/.cubiclauncher-gtk-wrapped" "$out/bin/cubiclauncher" \
      --run 'if ! { [ -e /sys/module/nvidia ] || [ -e /proc/driver/nvidia ] || command -v nvidia-smi >/dev/null 2>&1; }; then
        export __EGL_VENDOR_LIBRARY_FILENAMES="''${__EGL_VENDOR_LIBRARY_FILENAMES:-${mesa}/share/glvnd/egl_vendor.d/50_mesa.json}"
        export LIBGL_DRIVERS_PATH="''${LIBGL_DRIVERS_PATH:-${mesa}/lib/dri}"
        export GBM_BACKENDS_PATH="''${GBM_BACKENDS_PATH:-${mesa}/lib/gbm}"
        export LD_LIBRARY_PATH="${
          lib.makeLibraryPath [
            libglvnd
            libgbm
            wayland
            mesa
          ]
        }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      elif [ -z "''${CUBICLAUNCHER_WEBKIT_SOFTWARE:-}" ]; then
        if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] || [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          CUBICLAUNCHER_WEBKIT_SOFTWARE=1
        fi
      fi
      if [ "''${CUBICLAUNCHER_WEBKIT_SOFTWARE:-0}" = "1" ]; then
        export __NV_DISABLE_EXPLICIT_SYNC="''${__NV_DISABLE_EXPLICIT_SYNC:-1}"
        export WEBKIT_DISABLE_DMABUF_RENDERER="''${WEBKIT_DISABLE_DMABUF_RENDERER:-1}"
      fi'
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    if [ -f "$out/share/applications/cubiclauncher.desktop" ]; then
      desktop-file-edit \
        --set-key Exec --set-value "$out/bin/cubiclauncher" \
        --set-key Icon --set-value "$out/share/icons/hicolor/128x128/apps/cubiclauncher.png" \
        "$out/share/applications/cubiclauncher.desktop"
    fi
  '';

  meta = {
    description = "Open-source Minecraft: Java Edition launcher";
    homepage = "https://github.com/CubicLauncherDevs/CubicLauncher";
    changelog = "https://github.com/CubicLauncherDevs/CubicLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      santiagolxx
    ];
    mainProgram = "cubiclauncher";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
