{
  lib,
  stdenv,
  callPackage,
  fetchurl,

  # hooks
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,

  # native build inputs
  dpkg,
  unzip,

  # build inputs
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  dconf,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libgbm,
  libnotify,
  libusb1,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  qt6,
  systemdLibs,

  # runtime deps
  bubblewrap,
  libGL,
  libpulseaudio,
  libsecret,
  nodejs-slim,
  pipewire,
  ripgrep,
  tectonic-unwrapped,
  vulkan-loader,
  xdg-utils,
  # override to null to use bundled codex
  codex,
}:
let
  inherit (stdenv.hostPlatform) isLinux isDarwin system;
  inherit (stdenv.hostPlatform.node) arch platform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt";
  inherit (finalAttrs.passthru.source) version;

  src = fetchurl finalAttrs.passthru.source.src;

  strictDeps = true;
  __structuredAttrs = true;

  # autoPatchelf moves PT_INTERP beyond detect-libc's 2 KiB scan. Its
  # process.report fallback trips Electron's CFI, so use the glibc watcher.
  postPatch = lib.optionalString isLinux ''
    grep -aFq 'const family = familySync();' usr/lib/chatgpt/resources/app.asar
    sed -i "s|const family = familySync();|const family = 'glibc'     ;|" usr/lib/chatgpt/resources/app.asar
  '';

  nativeBuildInputs =
    lib.optionals isDarwin [ unzip ]
    ++ lib.optionals isLinux [
      autoPatchelfHook
      dpkg
      makeWrapper
      qt6.wrapQtAppsHook
      wrapGAppsHook3
    ];

  buildInputs = lib.optionals isLinux [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    dconf
    expat
    gdk-pixbuf
    glib
    gtk3
    libgbm
    libnotify
    libusb1
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    qt6.qtbase
    stdenv.cc.cc.lib
    systemdLibs
  ];

  runtimeDependencies = lib.optionals isLinux [
    libGL
    libnotify
    libpulseaudio
    libsecret
    pipewire
    vulkan-loader
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  sourceRoot = if isLinux then "root" else ".";

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString isDarwin ''
    mkdir -p "$out/Applications"
    mkdir -p "$out/bin"
    cp -a ChatGPT.app "$out/Applications"
    ln -s "$out/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" "$out/bin/ChatGPT"
  ''
  + lib.optionalString isLinux ''
    mkdir -p "$out"
    cp -r usr/* "$out"

    # Remove the unused Qt 5 fallback shim.
    rm -f "$out/lib/chatgpt/libqt5_shim.so"

    # Keep only the native prebuild for this platform and architecture.
    resources="$out/lib/chatgpt/resources"
    find "$resources" -type d -name prebuilds -print0 | while IFS= read -r -d "" prebuildsPath; do
      find "$prebuildsPath" -mindepth 1 -maxdepth 1 \
        ! -name "*${platform}-${arch}" \
        -exec rm -rf -- {} +
    done
    find "$resources" -type f -name '*.musl.node' -delete

    ln -sf ${lib.getExe tectonic-unwrapped} "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"
    ln -sf ${lib.getExe ripgrep} "$out/lib/chatgpt/resources/rg"
    ln -sf ${lib.getExe nodejs-slim} "$out/lib/chatgpt/resources/cua_node/bin/node"

    install -Dm755 ${lib.getExe finalAttrs.passthru.launcher} "$out/bin/chatgpt"
  ''
  + lib.optionalString (isLinux && codex != null) ''
    ln -sf ${lib.getExe codex} "$out/lib/chatgpt/resources/codex"
    ln -sf ${lib.getExe' codex "codex-code-mode-host"} "$out/lib/chatgpt/resources/codex-code-mode-host"
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString isLinux ''
    wrapProgram "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --set CHATGPT_EXECUTABLE "$out/lib/chatgpt/ChatGPT" \
      --set CHATGPT_RESOURCES_SOURCE "$out/lib/chatgpt/resources" \
      --set CHATGPT_RESOURCES_CACHE_LABEL ${lib.escapeShellArg "${finalAttrs.version}-${system}"} \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs-slim
          xdg-utils
          bubblewrap
        ]
      } \
      --set-default CODEX_BROWSER_USE_NODE_PATH ${lib.getExe nodejs-slim} \
      --set-default NODE_REPL_NODE_PATH ${lib.getExe nodejs-slim} \
      ${lib.escapeShellArgs (
        lib.optionals (codex != null) [
          "--set-default"
          "CODEX_CLI_PATH"
          (lib.getExe codex)
        ]
      )}
  '';

  dontStrip = true;

  passthru = {
    updateScript = ./update.sh;
    sources = lib.importJSON ./source.json;
    source = finalAttrs.passthru.sources.${system} or (throw "chatgpt is not supported on ${system}");
    launcher = callPackage ./launcher.nix { };
  };

  meta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://developers.openai.com/codex/app";
    changelog = "https://learn.chatgpt.com/docs/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wattmto
      moraxyc
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = if isDarwin then "ChatGPT" else "chatgpt";
  };
})
