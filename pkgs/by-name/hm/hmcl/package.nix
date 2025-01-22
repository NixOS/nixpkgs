{ lib
, stdenv
, fetchurl
, makeDesktopItem
, wrapGAppsHook3
, copyDesktopItems
, imagemagick
, jre
, xorg
, glib
, libGL
, glfw
, openal
, libglvnd
, alsa-lib
, wayland
, libpulseaudio
, gobject-introspection
}:

let
  version = "3.6.11";
  icon = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/raw/release-${version}/HMCLauncher/HMCL/HMCL.ico";
    hash = "sha256-+EYL33VAzKHOMp9iXoJaSGZfv+ymDDYIx6i/1o47Dmc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hmcl";
  inherit version;

  src = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/releases/download/release-${version}/HMCL-${version}.jar";
    hash = "sha256-ZQNJm7xbOdVSnxtx4krOnM9QBsxibFXo8wx1fCn1gJA=";
  };

  dontUnpack = true;

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "HMCL";
      exec = "hmcl";
      icon = "hmcl";
      comment = finalAttrs.meta.description;
      desktopName = "HMCL";
      categories = [ "Game" ];
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    copyDesktopItems
    imagemagick
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/hmcl}
    cp $src $out/lib/hmcl/hmcl.jar
    magick ${icon} hmcl.png
    install -Dm644 hmcl-1.png $out/share/icons/hicolor/32x32/apps/hmcl.png

    runHook postInstall
  '';

    fixupPhase =
      let
        libpath = lib.makeLibraryPath ([
          libGL
          glfw
          glib
          openal
          libglvnd
        ] ++ lib.optionals stdenv.hostPlatform.isLinux [
          xorg.libX11
          xorg.libXxf86vm
          xorg.libXext
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXtst
          libpulseaudio
          wayland
          alsa-lib
        ]);
      in ''
        runHook preFixup

        makeBinaryWrapper ${jre}/bin/java $out/bin/hmcl \
          --add-flags "-jar $out/lib/hmcl/hmcl.jar" \
          --set LD_LIBRARY_PATH ${libpath} \
          ''${gappsWrapperArgs[@]}

        runHook postFixup
      '';

  meta = with lib; {
    homepage = "https://hmcl.huangyuhui.net";
    description = "A Minecraft Launcher which is multi-functional, cross-platform and popular";
    mainProgram = "hmcl";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ daru-san ];
    inherit (jre.meta) platforms;
  };
})
