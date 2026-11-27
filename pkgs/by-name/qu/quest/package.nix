{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  at-spi2-core,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libGL,
  libappindicator,
  libgbm,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  makeShellWrapper,
  makeWrapper,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  unzip,
  vulkan-loader,
  wayland,
  wrapGAppsHook3,
  xdg-utils,
  commandLineArgs ? "",
}:

let
  pname = "quest";
  version = "0.8.7";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://packages.quest.app/linux/candidates/0.8.7/r3/7abef97a3a4ed4f57eaef6e727906200356148df/Quest-0.8.7-linux-amd64.deb";
      hash = "sha256-cywkMuzXOdnT4DRYC4zBKHVBs0VDN/xTLu3rlBLJN/c=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/steenfatt/quest-releases/releases/download/v${version}/Quest-${version}-arm64-mac.zip";
      hash = "sha256-eWwKE4hTcz6lbLOS40YYrng7FWLklau4RuZpmENKC3c=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  __structuredAttrs = true;
  strictDeps = true;
  dontStrip = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      dpkg
      makeShellWrapper
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeWrapper
      unzip
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    at-spi2-core
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
    systemdLibs
  ];

  # Loaded with dlopen() at runtime, so autoPatchelfHook cannot discover them automatically.
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux (
    map lib.getLib [
      libappindicator
      libnotify
      libpulseaudio
      libsecret
      libuuid
      libxscrnsaver
      libxtst
      pipewire
      vulkan-loader
      wayland
    ]
  );

  # Bundled ANGLE libraries (libEGL.so, libGLESv2.so) dlopen() system GL, and
  # the main binary loads bundled shared libraries (such as libffmpeg.so) from $out/lib/quest.
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "${lib.getLib libGL}/lib"
    "${placeholder "out"}/lib/quest"
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p "$out/Applications/Quest.app" "$out/bin"
        cp -a . "$out/Applications/Quest.app"
        makeWrapper "$out/Applications/Quest.app/Contents/MacOS/Quest" "$out/bin/quest" \
          --add-flags ${lib.escapeShellArg commandLineArgs}

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p "$out/bin" "$out/lib/quest" "$out/share"
        cp -r opt/Quest/* "$out/lib/quest/"
        cp -r usr/share/* "$out/share/"

        # Remove distro-specific updater scripts, AppImage launcher, AppArmor profile,
        # and foreign-architecture PowerSync shared libraries.
        rm -rf \
          "$out/lib/quest/AppRun" \
          "$out/lib/quest/resources/apparmor-profile" \
          "$out/lib/quest/resources/linux-updater" \
          "$out/lib/quest/resources/app/node_modules/@powersync/node/lib/libpowersync_aarch64.linux.so" \
          "$out/lib/quest/resources/app/node_modules/@powersync/node/lib/libpowersync_armv7.linux.so" \
          "$out/lib/quest/resources/app/node_modules/@powersync/node/lib/libpowersync_riscv64gc.linux.so" \
          "$out/lib/quest/resources/app/node_modules/@powersync/node/lib/libpowersync_x86.linux.so"

        substituteInPlace "$out/share/applications/me.steenfatt.quest.desktop" \
          --replace-fail "Exec=/opt/Quest/quest" "Exec=quest"

        runHook postInstall
      '';

  # Stripping or patching files inside the macOS app bundle would invalidate its code signature.
  dontFixup = stdenv.hostPlatform.isDarwin;

  # The wrapper is created manually in postFixup with makeShellWrapper so shell
  # variables in NIXOS_OZONE_WL flags expand at runtime.
  dontWrapGApps = stdenv.hostPlatform.isLinux;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeShellWrapper "$out/lib/quest/quest" "$out/bin/quest" \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Quest-hour accountability tool that connects goals, daily tasks, and focused work";
    homepage = "https://quest.app";
    downloadPage = "https://quest.app/download/";
    changelog = "https://github.com/steenfatt/quest-releases/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zimtechmeister ];
    mainProgram = "quest";
    platforms = lib.attrNames sources;
  };
})
