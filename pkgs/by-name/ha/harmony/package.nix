{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook4,
  copyDesktopItems,
  makeDesktopItem,

  # Linked and dlopen'd CEF/Chromium runtime libraries.
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  graphene,
  gsettings-desktop-schemas,
  gtk4,
  libdrm,
  libgbm,
  libGL,
  libpulseaudio,
  libva,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  speechd-minimal,
  systemdLibs,
  wayland,
}:

let
  # dlopen'd by Chromium/CEF, not listed in any DT_NEEDED entry (getLib picks
  # the runtime output; libva's default output is "dev").
  dlopenLibs = [
    libdrm
    libGL
    libpulseaudio
    libva
    libxshmfence
    pipewire
    speechd-minimal
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "harmony";
  version = "1.9.7";

  src = fetchurl {
    url = "https://github.com/y4my4my4m/harmony/releases/download/v${finalAttrs.version}/Harmony_Linux_V${finalAttrs.version}.deb";
    hash = "sha256-qfZuUzQi4mNTeRsn+1PhNNgRbcuVrnZ6/02YiLiqW7Q=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook4
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    graphene
    gsettings-desktop-schemas
    gtk4
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxtst
    nspr
    nss
    pango
    systemdLibs
    wayland
  ];

  # runtimeDependencies only reach executables, but CEF's dlopens happen inside
  # libcef.so and the ANGLE libraries, so append the directories to every file.
  appendRunpaths = map (p: "${lib.getLib p}/lib") dlopenLibs;

  # The CEF payload is a prebuilt binary with full debug info; stripping it
  # takes minutes and gains little.
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    # --no-same-permissions drops the setuid bit on chrome-sandbox, which the
    # unprivileged build user cannot set; the Nix store would not keep it anyway.
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
  '';

  sourceRoot = ".";

  desktopItems = [
    (makeDesktopItem {
      name = "harmony";
      desktopName = "Harmony";
      comment = "Federated Discord-like chat app";
      exec = "harmony %U";
      icon = "harmony";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      startupWMClass = "harmony";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/harmony
    cp -a usr/share/Harmony/. $out/libexec/harmony/

    # The deb bundle type disables the Tauri updater's in-place install, so it
    # cannot write outside the (read-only) store. Fail loudly if a future
    # release ships a self-updating Linux bundle instead.
    grep -q __TAURI_BUNDLE_TYPE_VAR_DEB $out/libexec/harmony/harmony || {
      echo "harmony: unexpected updater bundle type in harmony binary" >&2
      exit 1
    }

    install -Dm644 usr/share/icons/hicolor/32x32/apps/harmony.png \
      $out/share/icons/hicolor/32x32/apps/harmony.png
    install -Dm644 usr/share/icons/hicolor/128x128/apps/harmony.png \
      $out/share/icons/hicolor/128x128/apps/harmony.png
    install -Dm644 usr/share/icons/hicolor/256x256@2/apps/harmony.png \
      $out/share/icons/hicolor/256x256@2/apps/harmony.png

    runHook postInstall
  '';

  # wrapGAppsHook4 would wrap the binary on its own; the wrapper below is the
  # only one, so keep the hook from adding a second layer.
  dontWrapGApps = true;

  preFixup = ''
    # makeWrapper is the binary wrapper here (wrapGAppsHook4 pulls in
    # make-binary-wrapper-hook); --run needs the shell wrapper.
    makeShellWrapper $out/libexec/harmony/harmony $out/bin/harmony \
      "''${gappsWrapperArgs[@]}" \
      --set CHROME_WRAPPER harmony \
      --run 'if [ -x /run/wrappers/bin/chrome-sandbox ]; then
               export CHROME_DEVEL_SANDBOX=/run/wrappers/bin/chrome-sandbox
             fi'
  '';

  meta = {
    description = "Federated, Discord-like chat application with real-time messaging, voice calls and ActivityPub";
    longDescription = ''
      Harmony is a federated chat client for the Harmony network. This package
      wraps the official prebuilt Linux CEF (Chromium Embedded Framework)
      desktop release from its Debian package.
    '';
    homepage = "https://github.com/y4my4my4m/harmony";
    downloadPage = "https://github.com/y4my4my4m/harmony/releases";
    changelog = "https://github.com/y4my4my4m/harmony/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.WITH lib.licenses.agpl3Only (
      lib.licenses.mkLicense {
        shortName = "AdditionRef-Harmony";
        fullName = "Additional Terms for Harmony";
        url = "https://github.com/y4my4my4m/harmony/blob/v${finalAttrs.version}/LICENSE-ADDITIONAL-TERMS.md";
      }
    );
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "harmony";
    maintainers = [ lib.maintainers.ZaneH ];
  };
})
