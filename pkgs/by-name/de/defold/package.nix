{
  fetchzip,
  lib,
  libarchive,
  makeDesktopItem,
  buildFHSEnv,
}:
let
  version = "1.9.8";

  src = fetchzip {
    url = "https://github.com/defold/defold/releases/download/${version}/Defold-x86_64-linux.zip";
    hash = "sha256-Pn7jNw8oFZfgn5vHuJ3H9n+6YQ9cTev9ntDFrCiJI9s=";
  };

  # https://github.com/defold/defold/blob/67542769598a1b794877c96f740f3f527f63f491/editor/src/clj/editor/app_view.clj#L2748
  desktopItem = makeDesktopItem {
    name = "Defold";
    desktopName = "Defold";
    comment = "An out of the box, turn-key solution for multi-platform game development";
    terminal = false;
    type = "Application";
    startupWMClass = "com.defold.editor.Start";
    categories = [
      "Development"
      "IDE"
    ];
    startupNotify = true;
    exec = "Defold";
    icon = "defold";
  };
in
buildFHSEnv {
  pname = "defold";
  inherit version;

  targetPkgs =
    pkgs:
    (with pkgs; [
      alsa-lib
      glib
      gtk3
      jdk
      libgcc.lib
      libGL
      libGLU
      openal
    ])
    ++ (with pkgs.xorg; [
      libX11
      libXext
      libXi
      libXrender
      libXtst
      libXxf86vm
    ]);

  nativeBuildInputs = [
    libarchive
  ];

  extraInstallCommands = ''
    bsdtar -xf ${src}/packages/defold-*.jar --strip-components 2 icons/document.iconset

    install -Dm444 icon_16x16.png $out/share/icons/hicolor/16x16/apps/defold.png
    install -Dm444 icon_16x16@2x.png $out/share/icons/hicolor/32x32/apps/defold.png
    install -Dm444 icon_32x32@2x.png $out/share/icons/hicolor/64x64/apps/defold.png
    install -Dm444 icon_128x128.png $out/share/icons/hicolor/128x128/apps/defold.png
    install -Dm444 icon_256x256.png $out/share/icons/hicolor/256x256/apps/defold.png
    install -Dm444 icon_256x256@2x.png $out/share/icons/hicolor/512x512/apps/defold.png
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/Defold.desktop
  '';

  executableName = "Defold";
  runScript = "${src}/Defold";

  meta = {
    description = "Game engine for development of desktop, mobile and web games";
    homepage = "https://github.com/defold/defold";
    mainProgram = "Defold";
    license = [
      {
        fullName = "Defold License";
        url = "https://defold.com/license";
        free = false;
        redistributable = true;
      }
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ musjj ];
  };
}
