{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "arctracker-link";
  version = "2.1.8";

  src = fetchurl {
    url = "https://cdn.arctracker.io/link/linux/ARC-Tracker-Link-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-ERdbVsmIUwK6wA0LQDba0ZKYk6bvr4vXYJLEqYvokUg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract {
        inherit (finalAttrs) version pname src;
      };
    in
    # bash
    ''
      install -m 444 -D \
        ${appimageContents}/usr/share/applications/arctracker-link.desktop \
        "$out/share/applications/arctracker-link.desktop"
      install -m 444 -D \
        ${appimageContents}/usr/share/icons/hicolor/256x256/apps/arctracker-link.png \
        "$out/share/icons/hicolor/256x256/apps/arctracker-link.png"

      substituteInPlace "$out/share/applications/arctracker-link.desktop" \
        --replace-fail \
          'Exec=arctracker-link' \
          "Exec=$out/bin/arctracker-link"

      wrapProgram "$out/bin/arctracker-link" \
        --set APPIMAGE "$out/bin/arctracker-link"
    '';

  extraPkgs = pkgs: [
    pkgs.libayatana-appindicator
    pkgs.libsoup_3
    pkgs.webkitgtk_4_1
  ];

  meta = {
    description = "Link your ARC Raiders account with arctracker.io";
    homepage = "https://arctracker.io";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.PerchunPak ];
    mainProgram = "arctracker-link";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
