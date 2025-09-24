{
  alsa-lib,
  libuuid,
  cups,
  dpkg,
  fetchurl,
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
  systemd,
  stdenv,
  undmg,
  vips,
  at-spi2-core,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  commandLineArgs ? "",
}:

let
  sources = import ./sources.nix { inherit fetchurl; };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  pname = "qq";
  inherit (source) version src;
  passthru = {
    updateScript = ./update.sh;
  };
  meta = {
    homepage = "https://im.qq.com/index/";
    description = "Messaging app";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
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
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -a QQ.app $out/Applications

      runHook postInstall
    '';
  }
else
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

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
      vips
      xorg.libXdamage
    ];

    dontWrapGApps = true;

    runtimeDependencies = map lib.getLib [
      systemd
      libkrb5
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r opt $out/opt
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/qq.desktop \
        --replace-fail "/opt/QQ/qq" "$out/bin/qq" \
        --replace-fail "/usr/share" "$out/share"
      makeShellWrapper $out/opt/QQ/qq $out/bin/qq \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_PRELOAD : "${lib.makeLibraryPath [ libssh2 ]}/libssh2.so.1" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
            libuuid
          ]
        }" \
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
  }
