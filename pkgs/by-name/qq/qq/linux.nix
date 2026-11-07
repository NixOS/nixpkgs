{
  lib,
  stdenv,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  dpkg,
  writeShellApplication,

  alsa-lib,
  at-spi2-core,
  coreutils,
  cups,
  glib,
  gnused,
  gtk3,
  libdrm,
  libpulseaudio,
  libgcrypt,
  libkrb5,
  libgbm,
  nss,
  libxdamage,
  libssh2,
  libGL,
  libuuid,
  libayatana-appindicator,
  libnotify,
  systemdLibs,

  pname,
  passthru,
  meta,
  commandLineArgs,
  disableAutoUpdate,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (finalAttrs.passthru.source) version;
  inherit (finalAttrs.passthru) src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
    dpkg
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cups
    glib
    gtk3
    libdrm
    libpulseaudio
    libgcrypt
    libkrb5
    libgbm
    nss
    libxdamage
  ];

  dontWrapGApps = true;

  runtimeDependencies = map lib.getLib [
    systemdLibs
    libkrb5
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/qq.desktop \
      --replace-fail "Exec=/opt/QQ/qq" "Exec=qq" \
      --replace-fail "Icon=/usr/share/icons/hicolor/512x512/apps/qq.png" "Icon=qq"
    makeShellWrapper $out/opt/QQ/qq $out/bin/qq \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix LD_PRELOAD : "${lib.makeLibraryPath [ libssh2 ]}/libssh2.so.1" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libuuid
        ]
      }" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      "''${gappsWrapperArgs[@]}" ${lib.optionalString disableAutoUpdate ''
        \
        --set INTERNAL_VERSION "$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' $out/opt/QQ/resources/app/package.json)" \
        --run '${lib.getExe finalAttrs.passthru.versionConfigScript} || true'
      ''}

    # https://aur.archlinux.org/cgit/aur.git/commit/?h=linuxqq&id=f7644776ee62fa20e5eb30d0b1ba832513c77793
    rm -r $out/opt/QQ/resources/app/libssh2.so.1

    # https://github.com/microcai/gentoo-zh/commit/06ad5e702327adfe5604c276635ae8a373f7d29e
    ln -s ${libayatana-appindicator}/lib/libayatana-appindicator3.so \
      $out/opt/QQ/libappindicator3.so

    ln -s ${libnotify}/lib/libnotify.so \
      $out/opt/QQ/libnotify.so

    runHook postInstall
  '';

  passthru = passthru finalAttrs // {
    versionConfigScript = writeShellApplication {
      name = "qq-version-config.sh";
      runtimeInputs = [
        coreutils
        gnused
      ];
      text = lib.readFile ./version-config.sh;
    };
  };
  meta = meta finalAttrs;
})
