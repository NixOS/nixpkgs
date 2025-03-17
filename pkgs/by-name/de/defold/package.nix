{
  autoPatchelfHook,
  fetchFromGitHub,
  fetchzip,
  lib,
  libarchive,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  alsa-lib,
  glib,
  gtk3,
  jdk,
  libgcc,
  libGL,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "defold";
  version = "1.9.8";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://github.com/defold/defold/releases/download/${finalAttrs.version}/Defold-x86_64-linux.zip";
        hash = "sha256-Pn7jNw8oFZfgn5vHuJ3H9n+6YQ9cTev9ntDFrCiJI9s=";
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    makeWrapper
    libarchive
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk3
    jdk
    libgcc.lib
    libGL
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
  ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  # https://github.com/defold/defold/blob/67542769598a1b794877c96f740f3f527f63f491/editor/src/clj/editor/app_view.clj#L2748
  desktopItem = makeDesktopItem {
    name = "Defold";
    desktopName = "Defold";
    comment = "An out of the box, turn-key solution for multi-platform game development";
    terminal = false;
    type = "Application";
    startupWMClass = "com.defold.editor.Start";
    categories = [
      "Game"
      "Development"
      "IDE"
    ];
    startupNotify = true;
    exec = "Defold";
    icon = "defold";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r . $out/opt/Defold

    wrapProgram $out/opt/Defold/Defold \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    makeWrapper $out/opt/Defold/Defold $out/bin/Defold

    bsdtar -xf packages/defold-*.jar --strip-components 2 icons/document.iconset

    install -Dm444 icon_16x16.png $out/share/icons/hicolor/16x16/apps/defold.png
    install -Dm444 icon_16x16@2x.png $out/share/icons/hicolor/32x32/apps/defold.png
    install -Dm444 icon_32x32@2x.png $out/share/icons/hicolor/64x64/apps/defold.png
    install -Dm444 icon_128x128.png $out/share/icons/hicolor/128x128/apps/defold.png
    install -Dm444 icon_256x256.png $out/share/icons/hicolor/256x256/apps/defold.png
    install -Dm444 icon_256x256@2x.png $out/share/icons/hicolor/512x512/apps/defold.png
    install -Dm444 -t $out/share/applications $desktopItem/share/applications/Defold.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Defold is a completely free to use game engine for development of desktop, mobile and web games";
    homepage = "https://github.com/defold/defold";
    mainProgram = "Defold";
    license = with licenses; [ defold ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ musjj ];
  };
})
