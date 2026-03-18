{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  cups,
  qt6,
  undmg,
  xkeyboard-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "010editor";
  version = "16.0.4";

  src = finalAttrs.passthru.srcs.${stdenv.hostPlatform.system};

  sourceRoot = ".";

  strictDeps = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      copyDesktopItems
      makeWrapper
      qt6.wrapQtAppsHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cups
    qt6.qtbase
    qt6.qtwayland
    xkeyboard-config
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
          --set XKB_CONFIG_ROOT ${xkeyboard-config}/share/X11/xkb

        # Install icon
        install -D $out/opt/010_icon_128x128.png $out/share/icons/hicolor/128x128/apps/010.png
      '';
    in
    ''
      runHook preInstall
      ${if stdenv.hostPlatform.isDarwin then darwinInstall else linuxInstall}
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
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
    })
  ];

  passthru.srcs = {
    x86_64-linux = fetchzip {
      url = "https://download.sweetscape.com/010EditorLinux64Installer${finalAttrs.version}.tar.gz";
      hash = "sha256-M1D2Bmi45sYiB0Ci+0X0AxyIeR+On60xt4jP1Jsy5tA=";
    };

    x86_64-darwin = fetchurl {
      url = "https://download.sweetscape.com/010EditorMac64Installer${finalAttrs.version}.dmg";
      hash = "sha256-vsI0VgcJGleJTQ5C1JaiCkELfWfwgFhyCx+6j5mldIk=";
    };

    aarch64-darwin = fetchurl {
      url = "https://download.sweetscape.com/010EditorMacARM64Installer${finalAttrs.version}.dmg";
      hash = "sha256-+yU5JdPNS2BfiZLsBLyyC+ieVNqbIWba3teBlTIDWtk=";
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
