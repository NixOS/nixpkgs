{
  alsa-lib,
  libuuid,
  cups,
  dpkg,
  qq,
  glib,
  libssh2,
  gtk3,
  lib,
  libayatana-appindicator,
  libdrm,
  libgcrypt,
  libkrb5,
  libnotify,
  libgbm,
  libpulseaudio,
  libGL,
  nss,
  xorg,
  stdenv,
  nspr,
  dbus,
  libxext,
  pango,
  cairo,
  libx11,
  libxfixes,
  libxrandr,
  expat,
  libxcb,
  libxkbcommon,
  undmg,
  systemdMinimal,
  vips,
  at-spi2-core,
  buildFHSEnv,
  makeShellWrapper,
  wrapGAppsHook3,
  commandLineArgs ? "",
}:

let
  sources = qq.passthru.sources;
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  pname = "qq";
  inherit (source) version src;
  meta = {
    homepage = "https://im.qq.com/index/";
    description = "Messaging app";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      bot-wxt1221
      fee1-dead
      prince213
      ryan4yin
    ];
  };
in
buildFHSEnv rec {
  inherit
    pname
    version
    src
    meta
    ;
  qq-unwrapped = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      makeShellWrapper
      wrapGAppsHook3
      dpkg
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r opt $out/opt
      cp -r usr/share $out/share
      makeShellWrapper $out/opt/QQ/qq $out/bin/qq \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_PRELOAD : "${lib.makeLibraryPath [ libssh2 ]}/libssh2.so.1" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs} \
        "''${gappsWrapperArgs[@]}"

      # Remove bundled libraries
      rm -r $out/opt/QQ/resources/app/sharp-lib

      # https://aur.archlinux.org/cgit/aur.git/commit/?h=linuxqq&id=f7644776ee62fa20e5eb30d0b1ba832513c77793
      rm -r $out/opt/QQ/resources/app/libssh2.so.1

      # https://github.com/microcai/gentoo-zh/commit/06ad5e702327adfe5604c276635ae8a373f7d29e
      ln -s ${libayatana-appindicator}/lib/libayatana-appindicator3.so \
        $out/opt/QQ/libappindicator3.so

      ln -s ${libnotify}/lib/libnotify.so \
        $out/opt/QQ/libnotify.so

      runHook postInstall
    '';

    dontWrapGApps = true;
  };

  targetPkgs = pkgs: [
    qq-unwrapped
    alsa-lib
    at-spi2-core
    cups
    nspr
    glib
    gtk3
    pango
    cairo
    libdrm
    libpulseaudio
    libgcrypt
    libkrb5
    libgbm
    nss
    vips
    xorg.libXcomposite
    xorg.libXdamage
    systemdMinimal
    libx11
    dbus
    libxext
    libkrb5
    libxkbcommon
    libxfixes
    libxrandr
    expat
    libxcb
    libGL
    libuuid
    libssh2
  ];
  runScript = "qq";
  extraInstallCommands = ''
    mkdir -p "$out/share"
    cp -rf ${qq-unwrapped}/share/* $out/share/
    substituteInPlace $out/share/applications/qq.desktop \
      --replace-fail "/opt/QQ/qq" "$out/bin/qq" \
      --replace-fail "/usr/share" "$out/share"
  '';
}
