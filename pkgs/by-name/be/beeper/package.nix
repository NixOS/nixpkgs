{
  lib,
  stdenv,
  stdenvNoCC,
  runCommand,
  fetchurl,
  appimageTools,
  makeWrapper,
  asar,
  unzip,
  writeShellApplication,
  curl,
  common-updater-scripts,
}:
let
  pname = "beeper";
  version = "4.3.73";

  inherit (stdenv.hostPlatform) system;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}-x86_64.AppImage";
      hash = "sha256-j6HTTqU7+z8AJ20hYgia6wOH0/n3gxrUocCpMPmgQvQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}-arm64.AppImage";
      hash = "sha256-kWlKMZdicJ+DhGgYXCTqvSCYinI9QD0pJD4nb4yYdpI=";
    };
    aarch64-darwin = fetchurl {
      # Zip unpacks cleanly with unzip; the download API redirects to a .dmg.
      url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}-arm64-mac.zip";
      hash = "sha256-79T3pPLEt+tQQ2xoC3XBAI/xpxMdnY11qSmVA2VFiVw=";
    };
  };

  src = sources.${system} or (throw "beeper is not supported on ${system}");

  # Beeper 4.2.985+ ships AppImages without the type-2 magic bytes
  # (ASCII "AI" + 0x02 at ELF offset 8) that appimageTools.extract requires.
  linuxSrc = runCommand "Beeper-${version}-appimage" { inherit src; } ''
    cp $src $out
    chmod +w $out
    printf 'AI\x02' | dd of=$out bs=1 seek=8 conv=notrunc status=none
  '';

  meta = {
    description = "Universal chat app";
    longDescription = ''
      Beeper is a universal chat app. With Beeper, you can send
      and receive messages to friends, family and colleagues on
      many different chat networks.
    '';
    homepage = "https://beeper.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jshcmpbll
      zh4ngx
      aspauldingcode
    ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "beeper";
  };

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-beeper";
      runtimeInputs = [
        curl
        common-updater-scripts
      ];
      text = ''
        set -o errexit
        latestLinux="$(curl --silent --output /dev/null --write-out "%{redirect_url}\n" https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop)"
        version="$(echo "$latestLinux" | grep --only-matching --extended-regexp '[0-9]+\.[0-9]+\.[0-9]+')"
        for platform in ${lib.escapeShellArgs (lib.attrNames sources)}; do
          update-source-version beeper "$version" --ignore-same-version --source-key="passthru.sources.$platform"
        done
      '';
    });
  };

  linux =
    let
      appimageContents = appimageTools.extract {
        inherit pname version;
        src = linuxSrc;

        postExtract = ''
          appRoot="$out/resources/app"
          ${lib.getExe asar} extract "$out/resources/app.asar" "$appRoot"
          rm "$out/resources/app.asar"

          # disable creating a desktop file and icon in the home folder during runtime
          linuxConfigFilename=$appRoot/build/main/linux-*.mjs
          echo "export function registerLinuxConfig() {}" > $linuxConfigFilename

          # Disable scheduled update checks.
          autoUpdateConfigFilename=$(
            grep -lF 'c=d??{},p=c.hw_acceleration??!0' $appRoot/build/main/index-*.mjs
          )
          substituteInPlace "$autoUpdateConfigFilename" \
            --replace-fail 'c=d??{},p=c.hw_acceleration??!0' 'c={...(d??{}),auto_update_disabled:true},p=c.hw_acceleration??!0'

          # Disable user-triggered update checks, which ignore auto_update_disabled.
          substituteInPlace $appRoot/build/main/main-entry-*.mjs \
            --replace-fail 'async checkForUpdates(r=!1){' 'async checkForUpdates(r=!1){return;'
        '';
      };
    in
    appimageTools.wrapAppImage {
      inherit
        pname
        version
        meta
        passthru
        ;

      src = appimageContents;

      extraPkgs = pkgs: [ pkgs.libsecret ];

      extraInstallCommands = ''
        install -Dm 644 ${appimageContents}/beepertexts.png $out/share/icons/hicolor/512x512/apps/beepertexts.png
        install -Dm 644 ${appimageContents}/beepertexts.desktop -t $out/share/applications/
        substituteInPlace $out/share/applications/beepertexts.desktop --replace-fail "AppRun" "beeper"

        . ${makeWrapper}/nix-support/setup-hook
        wrapProgram $out/bin/beeper \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set APPIMAGE beeper \
          --run 'exec >/dev/null' # as recommended in #486164
      '';
    };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -r "Beeper Desktop.app" $out/Applications/
      makeWrapper "$out/Applications/Beeper Desktop.app/Contents/MacOS/Beeper Desktop" $out/bin/beeper

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
