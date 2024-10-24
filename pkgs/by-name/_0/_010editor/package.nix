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
  version = "15.0";

  src =
    if stdenv.isLinux then
      fetchzip {
        url = "https://download.sweetscape.com/010EditorLinux64Installer${finalAttrs.version}.tar.gz";
        hash = "sha256-mn7H0VDrBsuUYiBO3wWoCPWF/VxcdwAW6K5Yq1jCWzY=";
      }
    else
      fetchurl {
        url = "https://download.sweetscape.com/010EditorMac64Installer${finalAttrs.version}.dmg";
        hash = "sha256-4DvTtQu1jHc7XKwCWSvSRkitvEbGTwlpVmD1UvhG0NQ=";
      };

  sourceRoot = ".";

  strictDeps = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs =
    lib.optionals stdenv.isLinux [
      autoPatchelfHook
      makeWrapper
      qt5.wrapQtAppsHook
      stdenv.cc.cc
    ]
    ++ lib.optionals stdenv.isDarwin [ undmg ];

  buildInputs = lib.optionals stdenv.isLinux [
    cups
    qt5.qtbase
    qt5.qtwayland
  ];

  installPhase =
    let
      darwinInstall = "install -Dt $out/Applications *.app";
      linuxInstall = ''
        mkdir -p $out/opt && cp -ar source/* $out/opt

        # Patch executable runtime
        patchelf \
          --set-rpath ${stdenv.cc.cc.lib}/lib:${stdenv.cc.cc.lib}/lib64 \
          $out/opt/010editor

        # Unset wrapped QT plugins since they're already included in the package,
        # else the program crashes because of the conflict
        makeWrapper $out/opt/010editor $out/bin/010editor \
          --unset QT_PLUGIN_PATH

        # Copy the icon and generated desktop file
        install -D $out/opt/010_icon_128x128.png -t $out/share/icons/hicolor/128x128/apps/
        install -D $desktopItem/share/applications/* -t $out/share/applications/
      '';
    in
    ''
      runHook preInstall
      ${
        if stdenv.isDarwin then
          darwinInstall
        else if stdenv.isLinux then
          linuxInstall
        else
          "echo 'Unsupported Platform' && exit 1"
      }
      runHook postInstall
    '';

  desktopItem = makeDesktopItem {
    name = "010editor";
    exec = "010editor %f";
    icon = "010_icon_128x128";
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
    description = "Professional text and hex editor";
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
