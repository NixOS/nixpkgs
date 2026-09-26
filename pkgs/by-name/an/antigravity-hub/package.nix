{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  asar,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  cups,
  dbus,
  expat,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libGL,
  libgbm,
  libnotify,
  libpulseaudio,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  makeDesktopItem,
  makeShellWrapper,
  makeWrapper,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  unzip,
  wrapGAppsHook3,
}:

let
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-/C4q9JpFrv7pVYvOVqqku94A1WDTVDV68bg0qd1DzTM=";
    };
    aarch64-linux = {
      platform = "linux-arm";
      hash = "sha256-cgSbIH0cF5qFJKTc8TxPhtjLulmdhF/cRX3g9/ES6Rg=";
    };
    aarch64-darwin = {
      platform = "darwin-arm";
      hash = "sha256-0XWhNL4ssGNB2jJs4OqLgu3PaDaRBwP5hRKAMa1kP5w=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "antigravity-hub";
  version = "2.12.2";

  src =
    let
      source =
        sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      ext = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
    in
    fetchurl {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-hub/${finalAttrs.version}-${finalAttrs.passthru.buildId}/${source.platform}/Antigravity.${ext}";
      inherit (source) hash;
    };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      asar
      autoPatchelfHook
      copyDesktopItems
      makeShellWrapper
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeWrapper
      unzip
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gsettings-desktop-schemas
    gtk3
    libgbm
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
    systemd
  ];

  # Loaded with dlopen() by the main binary, so autoPatchelfHook cannot discover them.
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux (
    map lib.getLib [
      libnotify
      libpulseaudio
      libsecret
      pipewire
    ]
  );
  # The bundled ANGLE libraries (libEGL.so, libGLESv2.so) dlopen() the system GL
  # libraries. runtimeDependencies only applies to executables, so extend the
  # RUNPATH of every patched ELF file instead.
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [ "${lib.getLib libGL}/lib" ];

  # The wrapper is created in postFixup to add the Wayland flags.
  dontWrapGApps = true;

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "antigravity-hub";
      desktopName = "Antigravity";
      comment = "Manage multiple autonomous agents across independent projects";
      exec = "antigravity %U";
      icon = "antigravity";
      categories = [ "Development" ];
      mimeTypes = [ "x-scheme-handler/antigravity" ];
      startupWMClass = "Antigravity";
    })
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications/Antigravity.app
        cp -R . $out/Applications/Antigravity.app
        makeWrapper $out/Applications/Antigravity.app/Contents/MacOS/Antigravity $out/bin/antigravity

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/share/antigravity
        cp -r . $out/share/antigravity

        asar extract-file resources/app.asar icon.png
        install -Dm644 icon.png $out/share/icons/hicolor/512x512/apps/antigravity.png

        runHook postInstall
      '';

  # Stripping or patching files inside the app bundle would invalidate its code signature.
  dontFixup = stdenv.hostPlatform.isDarwin;

  # wrapGAppsHook3 provides makeBinaryWrapper, which cannot expand the shell
  # variables in --add-flags, hence makeShellWrapper.
  postFixup = ''
    makeShellWrapper $out/share/antigravity/antigravity $out/bin/antigravity \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  passthru = {
    # Download URLs embed a build ID next to the version, e.g. `2.12.2-6298742303883264`.
    buildId = "6298742303883264";
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop environment for managing multiple autonomous agents across independent projects";
    homepage = "https://antigravity.google";
    changelog = "https://antigravity.google/changelog";
    downloadPage = "https://antigravity.google/download";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames sources;
    mainProgram = "antigravity";
    maintainers = with lib.maintainers; [ BohdanTkachenko ];
  };
})
