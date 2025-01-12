{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  cups,
  qt5,
  undmg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "010editor";
  version = "15.0.1";

  src =
    if stdenv.hostPlatform.isLinux then
      fetchzip {
        url = "https://download.sweetscape.com/010EditorLinux64Installer${finalAttrs.version}.tar.gz";
        hash = "sha256-/Bfm/fPX3Szla23U9+qoq99E2v8jC3f9pgkJMTxNFUk=";
      }
    else
      fetchurl {
        url = "https://download.sweetscape.com/010EditorMac64Installer${finalAttrs.version}.dmg";
        hash = "sha256-hpDhcX1xS4Nry2HOIrFwqYK45JOmy66lPq6dJr9pkQg=";
      };

  sourceRoot = ".";

  strictDeps = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      makeWrapper
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cups
    qt5.qtbase
    qt5.qtwayland
  ];

  installPhase =
    let
      darwinInstall = ''
        mkdir -p $out/Applications
        cp -R *.app $out/Applications
      '';
      linuxInstall = ''
        mkdir -p $out/opt && cp -ar source/* $out/opt

        # Unset wrapped QT plugins since they're already included in the package,
        # else the program crashes because of the conflict
        makeWrapper $out/opt/010editor $out/bin/010editor \
          --unset QT_PLUGIN_PATH

        # Copy the icon and generated desktop file
        install -D $out/opt/010_icon_128x128.png $out/share/icons/hicolor/128x128/apps/010.png
        install -D $desktopItem/share/applications/* -t $out/share/applications/
      '';
    in
    ''
      runHook preInstall
      ${
        if stdenv.hostPlatform.isDarwin then
          darwinInstall
        else if stdenv.hostPlatform.isLinux then
          linuxInstall
        else
          "echo 'Unsupported Platform' && exit 1"
      }
      runHook postInstall
    '';

  desktopItem = makeDesktopItem {
    name = "010editor";
    exec = "010editor %f";
    icon = "010";
    desktopName = "010 Editor";
    genericName = "Text and hex edtior";
    categories = [ "Development" ];
    mimeTypes = [
      "text/html"
      "text/plain"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/xml"
    ];
  };

  meta = {
    description = "Text and hex editor";
    homepage = "https://www.sweetscape.com/010editor/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "010editor";
  };
})
