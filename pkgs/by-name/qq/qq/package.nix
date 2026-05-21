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
  libxdamage,
  systemd,
  stdenv,
  undmg,
  vips,
  at-spi2-core,
  autoPatchelfHook,
  writeShellScript,
  makeShellWrapper,
  wrapGAppsHook3,
  commandLineArgs ? "",
  disableAutoUpdate ? true,
}:

let
  sources = import ./sources.nix { inherit fetchurl; };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  pname = "qq";
  inherit (source) version src;
  passthru = {
    # nixpkgs-update: no auto update
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
      libxdamage
    ];

    dontWrapGApps = true;

    runtimeDependencies = map lib.getLib [
      systemd
      libkrb5
    ];

    installPhase =
      let
        versionConfigScript = writeShellScript "qq-version-config.sh" ''
          set -e

          if [[ -z "$INTERNAL_VERSION" ]]; then
            echo "INTERNAL_VERSION is not set, skipping version config management"
            exit 0
          fi

          CONFIG_PATH="$HOME/.config/QQ/versions/config.json"
          CONFIG_DIR="$(dirname "$CONFIG_PATH")"

          if [[ ! -f "$CONFIG_PATH" ]]; then
            if [[ ! -d "$CONFIG_DIR" ]]; then
              echo "Creating QQ version config directory at $CONFIG_DIR"
              mkdir -p "$CONFIG_DIR"
            fi
          else
            baseVersion=$(sed -n 's/.*"baseVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_PATH")
            currentVersion=$(sed -n 's/.*"curVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_PATH")

            # Here we assert that the buildId is the same as baseVersion's buildId and skip checking it separately
            if [[ "$baseVersion" == "$INTERNAL_VERSION" && "$currentVersion" == "$INTERNAL_VERSION" ]]; then
              echo "Version config file already up to date"

              if [[ -w "$CONFIG_PATH" ]]; then
                echo "Making existing version config file read-only"
                chmod u-w "$CONFIG_PATH"
              fi

              exit 0
            fi

            if [[ ! -w "$CONFIG_PATH" ]]; then
              echo "Making existing version config file writable temporarily"
              chmod u+w "$CONFIG_PATH"
            fi
          fi

          cat > "$CONFIG_PATH" << EOF
          {
            "_comment": "This file is managed by the qq-version-config.sh to disable auto updates, do not edit it manually. Set the `disableAutoUpdate` option to false to disable this behavior.",
            "baseVersion": "$INTERNAL_VERSION",
            "curVersion": "$INTERNAL_VERSION",
            "buildId": "''${INTERNAL_VERSION##*-}"
          }
          EOF

          chmod u-w "$CONFIG_PATH"
        '';
      in
      ''
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
          "''${gappsWrapperArgs[@]}" ${lib.optionalString disableAutoUpdate ''
            \
            --set INTERNAL_VERSION "$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' $out/opt/QQ/resources/app/package.json)" \
            --run '${versionConfigScript} || true'
          ''}

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
