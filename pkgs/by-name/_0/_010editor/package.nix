{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  cups,
  qt6,
  undmg,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "010editor";
  version = "16.0.1";

  src = finalAttrs.passthru.srcs.${stdenv.hostPlatform.system};

  sourceRoot = ".";

  strictDeps = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      makeWrapper
      qt6.wrapQtAppsHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cups
    qt6.qtbase
    qt6.qtwayland
    xorg.xkeyboardconfig
  ];

  installPhase =
    let
      darwinInstall = ''
        mkdir -p $out/Applications
        cp -R *.app $out/Applications
      '';

      linuxInstall = ''
        mkdir -p $out/opt && cp -ar source/* $out/opt

        # Wrap binary: clean env, fix XKB lookup
        makeWrapper $out/opt/010editor $out/bin/010editor \
          --unset QT_PLUGIN_PATH \
          --set XKB_CONFIG_ROOT ${xorg.xkeyboardconfig}/share/X11/xkb

        # Install icon + desktop entry
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
    genericName = "Text and hex editor";
    categories = [ "Development" ];
    mimeTypes = [
      "text/html"
      "text/plain"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/xml"
    ];
  };

  passthru.srcs = {
    x86_64-linux = fetchzip {
      url = "https://download.sweetscape.com/010EditorLinux64Installer${finalAttrs.version}.tar.gz";
      hash = "sha256-fPQCVA9VrpNBTA7PiOsHwIiaZLKKoK817PtWNX8uHBQ=";
    };

    x86_64-darwin = fetchurl {
      url = "https://download.sweetscape.com/010EditorMac64Installer${finalAttrs.version}.dmg";
      hash = "sha256-q/lfe4IWYJbxoGVBQju+t/w13UI3XHaVNPdTjnIQFw8=";
    };

    aarch64-darwin = fetchurl {
      url = "https://download.sweetscape.com/010EditorMacARM64Installer${finalAttrs.version}.dmg";
      hash = "sha256-kBrYSxTNz01pPaRfKZWE6dDoACgs5tlfb+M6A7R0Vo4=";
    };
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
