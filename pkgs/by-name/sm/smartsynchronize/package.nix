{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  openjdk21,
  gtk3,
  glib,
  adwaita-icon-theme,
  wrapGAppsHook3,
  libXtst,
  which,
}:
let
  jre = openjdk21;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smartsynchronize";
  version = "4.6.2";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/smartsynchronize/smartsynchronize-linux-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.tar.gz";
    hash = "sha256-78CidB6d7FJH17rRT3N9tCCHNZyeyOy7DOepxVDLPUM=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    jre
    adwaita-icon-theme
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=( \
      --prefix PATH : ${
        lib.makeBinPath [
          jre
          which
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          gtk3
          glib
          libXtst
        ]
      } \
      --prefix JAVA_HOME : ${jre} \
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/{bin,share/applications,share/icons/hicolor/scalable/apps/}
    cp -av ./lib $out/
    cp -av bin/smartsynchronize.sh $out/bin/smartsynchronize

    cp -av $desktopItem/share/applications/* $out/share/applications/
    for icon_size in 32 48 64 128 256; do
        path=$icon_size'x'$icon_size
        icon=bin/smartsynchronize-$icon_size.png
        mkdir -p $out/share/icons/hicolor/$path/apps
        cp $icon $out/share/icons/hicolor/$path/apps/smartsynchronize.png
    done

    cp -av bin/smartsynchronize.svg $out/share/icons/hicolor/scalable/apps/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "smartsynchronize";
    exec = "smartsynchronize";
    comment = finalAttrs.meta.description;
    icon = "smartsynchronize";
    desktopName = "SmartSynchronize";
    categories = [ "Development" ];
    startupNotify = true;
    startupWMClass = "smartsynchronize";
    keywords = [
      "compare"
      "file manager"
    ];
  };

  meta = {
    description = "File Manager, File/Directory Compare";
    longDescription = ''
      SmartSynchronize is a dual-pane, keyboard-centric, multi-platform file manager.
      It also is known for its file compare, directory compare and file merge.
      SmartSynchronize is free to use for active Open Source developers and users from academic institutions.
    '';
    homepage = "https://www.syntevo.com/smartsynchronize/";
    changelog = "https://www.syntevo.com/smartsynchronize/changelog-${lib.versions.majorMinor finalAttrs.version}.txt";
    license = lib.licenses.unfree;
    mainProgram = "smartsynchronize";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tmssngr ];
  };
})
