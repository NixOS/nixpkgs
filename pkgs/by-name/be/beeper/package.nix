{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeShellApplication,
  curl,
  yq,
  common-updater-scripts,
}:
let
  pname = "beeper";
  version = "4.0.584";
  src = fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}.AppImage";
    hash = "sha256-xKOVU1AiOfC7QIMn0ErUDVOVjho6cm2qXY1X2zk2kgs=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit version pname src;

    postExtract = ''
      # disable creating a desktop file and icon in the home folder during runtime
      linuxConfigFilename=$out/resources/app/build/main/linux-*.mjs
      echo "export function registerLinuxConfig() {}" > $linuxConfigFilename
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    mkdir -p $out/share/
    cp -a ${appimageContents}/usr/share/icons $out/share/icons
    install -Dm 644 ${appimageContents}/beepertexts.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/beepertexts.desktop --replace-fail "AppRun" "beeper"

    . ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/beeper \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update" \
      --set APPIMAGE beeper
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-beeper";
      runtimeInputs = [
        curl
        yq
        common-updater-scripts
      ];
      text = ''
        set -o errexit
        latestLinux="$(curl -s https://download.todesktop.com/2003241lzgn20jd/latest-linux.yml)"
        version="$(echo "$latestLinux" | yq -r .version)"
        update-source-version beeper "$version" "" "https://download.beeper.com/versions/$version/linux/appImage/x64" --source-key=src.src
      '';
    });
  };

  meta = with lib; {
    description = "Universal chat app";
    longDescription = ''
      Beeper is a universal chat app. With Beeper, you can send
      and receive messages to friends, family and colleagues on
      many different chat networks.
    '';
    homepage = "https://beeper.com";
    license = licenses.unfree;
    maintainers = with maintainers; [
      jshcmpbll
      mjm
      edmundmiller
    ];
    platforms = [ "x86_64-linux" ];
  };
}
