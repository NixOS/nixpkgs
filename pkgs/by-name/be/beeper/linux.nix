{
  appimageTools,
  makeWrapper,
  meta,
  passthru,
  pname,
  src,
  version,
}:
let
  appimageContents = appimageTools.extract {
    inherit pname src version;

    postExtract = ''
      # disable creating a desktop file and icon in the home folder during runtime
      linuxConfigFilename=$out/resources/app/build/main/linux-*.mjs
      echo "export function registerLinuxConfig() {}" > $linuxConfigFilename

      # disable auto update
      sed -i 's/[^=]*\.auto_update_disabled/true/' $out/resources/app/build/main/main-entry-*.mjs

      # prevent updates
      sed -i -E 's/executeDownload\([^)]+\)\{/executeDownload(){return;/g' $out/resources/app/build/main/main-entry-*.mjs

      # hide version status element on about page otherwise a error message is shown
      sed -i '$ a\.subview-prefs-about > div:nth-child(2) {display: none;}' $out/resources/app/build/renderer/PrefsPanes-*.css
    '';
  };
in
appimageTools.wrapAppImage {
  inherit
    meta
    passthru
    pname
    version
    ;
  src = appimageContents;
  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -Dm 644 ${appimageContents}/beepertexts.png $out/share/icons/hicolor/512x512/apps/beepertexts.png
    install -Dm 644 ${appimageContents}/beepertexts.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/beepertexts.desktop --replace-fail "AppRun" "beeper"

    . ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/beeper \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update" \
      --set APPIMAGE beeper
  '';
}
