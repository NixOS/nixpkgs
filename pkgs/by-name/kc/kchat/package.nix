{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  testers,
  writeScript,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libappindicator,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libxcb,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  wayland,
}:

let
  pname = "kchat";
  version = "3.5.3";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://download.storage5.infomaniak.com/kchat/kchat-desktop-${version}-linux-x64.tar.gz";
      hash = "sha256-+6+C3Y1ua+GJaWRRQ5uRIg/tSl5Cven1Nl1AT9AkP3Q=";
    };
    # aarch64-linux artifacts are not published upstream yet
  };
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;

  # Kept explicitly: the previous AppImage-based package already evaluated
  # with structured attrs (nixpkgs-vet NPV-167).
  __structuredAttrs = true;

  # Wrapping is done manually in installPhase with gappsWrapperArgs; the hook
  # must only collect the arguments, not wrap on its own.
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    # Mirrors the deb dependencies (libnotify4, libxtst6, libnss3) plus the
    # standard Electron runtime set.
    stdenv.cc.cc
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libappindicator
    libdrm
    libgbm
    libnotify
    libxcb
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    mesa
    nspr
    nss
    pango
    pipewire
    systemd
    wayland
  ];

  # dlopen'ed at runtime by Electron/Chromium, so their store paths must land
  # on every patched ELF's RUNPATH (autoPatchelf only resolves DT_NEEDED).
  runtimeDependencies = [
    libappindicator # tray icons (StatusNotifier)
    libglvnd # ANGLE dlopens libEGL.so.1 for GPU initialization
    libnotify # desktop notifications
    mesa # GL fallback
    pipewire # screen sharing on Wayland (WebRTCPipeWireCapturer)
    systemd # libudev
  ];

  # The bundled ANGLE libraries (libEGL.so, libGLESv2.so) dlopen the system
  # libEGL.so.1 at runtime for GPU initialization. autoPatchelfHook only
  # extends the RUNPATH of executables, not of shared libraries, so ask it to
  # append libglvnd to every RUNPATH instead. Entries added manually in
  # postFixup would be dropped by the hook's rewrite; appendRunpaths survives
  # it. GLvnd then locates the GL vendor through its compiled-in config dirs
  # (/run/opengl-driver/share/glvnd/egl_vendor.d on NixOS).
  appendRunpaths = [ "${lib.getLib libglvnd}/lib" ];

  # The bundled Electron binary and its libraries are prebuilt: only patch
  # ELF metadata, never strip.
  dontStrip = true;
  dontBuild = true;

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-*.so.*"
    "libcuda.so.*"
    "libnvidia-*.so.*"
  ];

  # electron-builder may wrap the dist in a top-level directory for tar.gz
  # targets; fall into it when the expected files are not at the root.
  setSourceRoot = ''
    if [ ! -d resources ]; then
      for d in */; do
        if [ -d "''${d}resources" ]; then
          sourceRoot="''${d%/}"
          break
        fi
      done
    fi
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.infomaniak.chat";
      desktopName = "kChat";
      comment = "kChat Desktop application for Linux";
      exec = "kchat %u";
      icon = "kchat";
      startupWMClass = "kchat-desktop";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      # Deep-link schemes: "kchat" from the app protocols, "ktalk" from the
      # kMeet integration.
      mimeTypes = [
        "x-scheme-handler/kchat"
        "x-scheme-handler/ktalk"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    appDir=$out/share/kchat-desktop
    mkdir -p $out/bin "$appDir"
    cp -r . "$appDir/"

    # Bundled executable name (matches the upstream create_desktop_file.sh).
    if [ ! -x "$appDir/kchat-desktop" ]; then
      echo "kchat-desktop executable not found in the tarball; dist contents:" >&2
      ls -A "$appDir" >&2
      exit 1
    fi

    # The SUID chrome-sandbox cannot work from the read-only Nix store; remove
    # it so Chromium falls back to the user-namespace sandbox instead of
    # aborting on a misconfigured helper.
    rm -f "$appDir/chrome-sandbox"

    # Neutralize electron-updater: updates are handled by Nix. The app-side
    # updater is already inert on Linux outside AppImage (canUpgrade in
    # src/common/config/index.ts), removing the S3 feed file makes this hold
    # even if that logic changes.
    rm -f "$appDir/resources/app-update.yml"

    # Electron Wayland convention from nixpkgs (NIXOS_OZONE_WL): the Ozone
    # Wayland backend with platform auto-detection is opt-in.
    # gappsWrapperArgs brings GSettings schemas, GDK pixbuf loaders and GIO
    # modules; glib's bin puts gsettings on PATH for the app's
    # do-not-disturb detection.
    gappsWrapperArgsHook
    makeWrapper "$appDir/kchat-desktop" $out/bin/kchat \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.getBin glib}/bin \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    if [ -f app_icon.png ]; then
      install -Dm644 app_icon.png $out/share/icons/hicolor/512x512/apps/kchat.png
    fi

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      # The app insists on being able to write to a log file at startup.
      command = "env HOME=/tmp kchat --version";
    };

    # Releases are published to an S3 bucket with an electron-updater channel
    # file; scrape it instead of a git release feed.
    updateScript = writeScript "update-kchat" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl common-updater-scripts
      set -euo pipefail
      version="$(curl -s https://download.storage5.infomaniak.com/kchat/latest-linux.yml | sed -n 's/^version: *//p')"
      update-source-version kchat "$version"
    '';
  };

  meta = with lib; {
    description = "Desktop client for Infomaniak kChat";
    homepage = "https://infomaniak.com/kchat";
    license = licenses.unfree;
    mainProgram = "kchat";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ vinetos ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    longDescription = ''
      kChat is an instant messaging service which enables you to discuss, share and coordinate your teams in complete
      security via your Internet browser, mobile phone, tablet or computer.
    '';
  };
})
