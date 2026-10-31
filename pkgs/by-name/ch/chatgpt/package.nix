{
  lib,
  stdenv,
  callPackage,
  fetchurl,

  # hooks
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,

  # native build inputs
  asar,
  dpkg,
  patchelf,
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
  tpm2-tss,

  # runtime deps
  bubblewrap,
  coreutils,
  gitMinimal,
  libGL,
  libpulseaudio,
  libsecret,
  lsb-release,
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

  postPatch =
    lib.optionalString isLinux ''
      # autoPatchelf moves PT_INTERP beyond detect-libc's 2 KiB limit.
      # Its process.report fallback crashes Electron.
      asar extract usr/lib/chatgpt/resources/app.asar app
      substituteInPlace app/node_modules/@parcel/watcher/index.js \
        --replace-fail 'const family = familySync();' "const family = '${stdenv.hostPlatform.libc}';"
    ''
    # Use the Nix-built primary runtime instead of downloading an unpatched one.
    # Anchors avoid minified names that change between releases.
    + lib.optionalString (finalAttrs.passthru.primaryRuntime != null) ''
      # Like --replace-fail, but requires an exact match count across the bundle.
      replaceInBundle() {
        local expected=$1 from=$2 to=$3 found
        found=$({ grep -ohF -- "$from" app/.vite/build/*.js || true; } | wc -l)
        if (( found != expected )); then
          echo "expected $expected occurrence(s) of '$from', found $found" >&2
          exit 1
        fi
        substituteInPlace $(grep -lF -- "$from" app/.vite/build/*.js) --replace-fail "$from" "$to"
      }

      # Resolve the default runtime root to the nix store.
      replaceInBundle 4 'homedir(),".cache","codex-runtimes")' 'homedir()&&"${finalAttrs.passthru.primaryRuntime}/lib")'

      # Refuse to install or update it.
      replaceInBundle 1 '="manual_install"}){' '="manual_install"}){throw Error("The Codex runtime is managed by Nix.");'
      replaceInBundle 1 'getStaticDisabledReason(){' 'getStaticDisabledReason(){return"managed-by-nix";'

      # Sync its bundled plugins at startup like the read-only Windows runtime, from a writable copy.
      replaceInBundle 1 '.resolve()))return()=>void 0;' '.resolve())&&!1)return()=>void 0;'
      replaceInBundle 1 '"framework"===(0,' '!0||"framework"===(0,'
      replaceInBundle 1 '.rename(n,r),r}' \
        '.rename(n,r),require("node:child_process").execFileSync("${lib.getExe' coreutils "chmod"}",["-R","u+w",r]),r}'

      for js in app/.vite/build/*.js; do node --check "$js"; done
    ''
    + lib.optionalString isLinux ''
      # Don't pack packages that were originally unpacked
      unpackedDirs="$(
        # Only descend into @scope directories
        find usr/lib/chatgpt/resources/app.asar.unpacked/node_modules \
          -mindepth 1 -maxdepth 2 \
          ! -name '@*' -printf '%P\n' -prune |
          paste -sd,
      )"
      asar pack app usr/lib/chatgpt/resources/app.asar \
        --unpack-dir "node_modules/{$unpackedDirs}"
    '';

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (finalAttrs.passthru.primaryRuntime != null) [ nodejs-slim ]
  ++ lib.optionals isDarwin [
    unzip
    patchelf
  ]
  ++ lib.optionals isLinux [
    asar
    autoPatchelfHook
    dpkg
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
    tpm2-tss
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
  + (
    if isDarwin then
      ''
        mkdir -p "$out/Applications" "$out/bin"
        cp -a ChatGPT.app "$out/Applications"
        makeWrapper "$out/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" "$out/bin/ChatGPT"
      ''
    else
      ''
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
      ''
      + lib.optionalString stdenv.hostPlatform.isGnu ''
        find "$resources" -type f -name '*.musl.node' -delete
      ''
      + ''
        ln -sf ${lib.getExe tectonic-unwrapped} "$resources/tectonic/tectonic"
        ln -sf ${lib.getExe ripgrep} "$resources/rg"
        mkdir -p "$resources/cua_node/bin"
        ln -sf ${lib.getExe nodejs-slim} "$resources/cua_node/bin/node"

        install -Dm755 ${lib.getExe finalAttrs.passthru.launcher} "$out/bin/chatgpt"
        install -Dm644 ${./tmpfiles.conf} "$out/share/user-tmpfiles.d/chatgpt.conf"
      ''
      + lib.optionalString (codex != null) ''
        ln -sf ${lib.getExe codex} "$resources/codex"
        ln -sf ${lib.getExe' codex "codex-code-mode-host"} "$resources/codex-code-mode-host"
      ''
      + ''
        # The launcher assumes this bundled-plugin resource layout.
        for resource in codex codex-code-mode-host cua_node native rg tectonic plugins; do
          if [[ ! -e "$resources/$resource" ]]; then
            echo "Missing ChatGPT bundled-plugin resource: $resources/$resource" >&2
            exit 1
          fi
        done
      ''
  )
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString isLinux ''
    wrapProgram "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --set CHATGPT_EXECUTABLE "$out/lib/chatgpt/ChatGPT" \
      --set CHATGPT_RESOURCES_SOURCE "$out/lib/chatgpt/resources" \
      --set CHATGPT_RESOURCES_CACHE_KEY "''${out##*/}" \
      --prefix PATH : ${
        lib.makeBinPath [
          bubblewrap
          coreutils
          gitMinimal
          lsb-release
          nodejs-slim
          nodejs-slim.npm
          xdg-utils
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
  dontPatchELF = isDarwin;
  dontPatchShebangs = isDarwin;

  doInstallCheck = isLinux;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = ./update.sh;
    sources = lib.importJSON ./source.json;
    source = finalAttrs.passthru.sources.${system} or (throw "chatgpt is not supported on ${system}");
    primaryRuntime =
      if (finalAttrs.passthru.source.primaryRuntime or null) != null then
        callPackage ./primary-runtime.nix { inherit (finalAttrs.passthru) source sources; }
      else
        null;
    launcher = callPackage ./launcher.nix { };
  };

  meta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://developers.openai.com/codex/app";
    changelog = "https://learn.chatgpt.com/docs/changelog?type=codex-app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wattmto
      moraxyc
      mdaniels5757
    ];
    broken = stdenv.hostPlatform.isMusl;
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = if isDarwin then "ChatGPT" else "chatgpt";
  };
})
