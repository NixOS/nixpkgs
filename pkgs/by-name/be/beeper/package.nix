{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  asar,
  writeShellApplication,
  curl,
  common-updater-scripts,
}:
let
  pname = "beeper";
  version = "4.2.948";
  src = fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}-x86_64.AppImage";
    hash = "sha256-MvfQSCV8b5aOeOSlTnRlOupzg+wmHhG0hGWznwCx0Yc=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;

    postExtract = ''
      appRoot="$out/resources/app"
      ${lib.getExe asar} extract "$out/resources/app.asar" "$appRoot"
      rm "$out/resources/app.asar"

      # disable creating a desktop file and icon in the home folder during runtime
      linuxConfigFilename=$appRoot/build/main/linux-*.mjs
      echo "export function registerLinuxConfig() {}" > $linuxConfigFilename

      # disable auto update
      sed -i 's/c=d??{},p=c.hw_acceleration??!0/c={...(d??{}),auto_update_disabled:true},p=c.hw_acceleration??!0/g' $appRoot/build/main/index-*.mjs

      # prevent updates
      sed -i -E 's/executeDownload\([^)]+\)\{/executeDownload(){return;/g' $appRoot/build/main/main-entry-*.mjs

      # hide version status element on about page otherwise an error message is shown
      sed -i '$ a\.subview-prefs-about > div:nth-child(2) {display: none;}' $appRoot/build-browser/*.css

    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -Dm 644 ${appimageContents}/beepertexts.png $out/share/icons/hicolor/512x512/apps/beepertexts.png
    install -Dm 644 ${appimageContents}/beepertexts.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/beepertexts.desktop --replace-fail "AppRun" "beeper"

    . ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/beeper \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update" \
      --set APPIMAGE beeper \
      --run 'exec >/dev/null' # as recommended in #486164
  '';

  passthru = {
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
        update-source-version beeper "$version"
      '';
    });

    # needed for nix-update
    inherit src;
  };

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
    ];
    platforms = [ "x86_64-linux" ];
  };
}
