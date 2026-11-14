{
  alsa-lib,
  atk,
  cairo,
  ffmpeg,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  harfbuzz,
  jre,
  lib,
  libGL,
  libglvnd,
  libx11,
  libxext,
  libxinerama,
  libxrandr,
  libxrender,
  libxxf86vm,
  libxcursor,
  libxi,
  libxtst,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  pango,
  stdenv,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netlogo";
  version = "7.0.4";

  src = fetchurl {
    url = "https://downloads.netlogo.org/${finalAttrs.version}/NetLogo-${finalAttrs.version}-64.tgz";
    hash = "sha256-dWNrhGnqSZXsBRz7yR5SXxcb6EuPlZuGvAgPv/cC37w=";
  };

  sourceRoot = "NetLogo ${finalAttrs.version}";

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
  ];

  dontBuild = true;
  dontConfigure = true;
  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "netlogo";
      exec = "netlogo";
      icon = "netlogo";
      comment = "A multi-agent programmable modeling environment";
      desktopName = "NetLogo";
      categories = [ "Science" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/netlogo
    cp -r . $out/opt/netlogo
    # the bundled JRE is not used: the package runs on the nixpkgs `jre`
    rm -rf $out/opt/netlogo/lib/runtime

    # launcher with `cd` is required b/c otherwise the model library isn't usable
    makeWrapper ${jre}/bin/java $out/bin/netlogo \
      "''${gappsWrapperArgs[@]}" \
      --chdir $out/opt/netlogo \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          gtk3
          glib
          gdk-pixbuf
          cairo
          pango
          atk
          harfbuzz
          fontconfig
          freetype
          libGL
          libglvnd
          libx11
          libxext
          libxrender
          libxtst
          libxinerama
          libxcursor
          libxi
          libxrandr
          libxxf86vm
          alsa-lib
          ffmpeg
          stdenv.cc.cc
        ]
      } \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --add-flags "-XX:MaxRAMPercentage=50" \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-Dnetlogo.docs.dir=$out/opt/netlogo" \
      --add-flags "-Dnetlogo.extensions.dir=$out/opt/netlogo/extensions" \
      --add-flags "-Dnetlogo.models.dir=$out/opt/netlogo/models" \
      --add-flags "-Djava.library.path=$out/opt/netlogo/natives/linux-amd64" \
      --add-flags "--add-exports=java.base/java.lang=ALL-UNNAMED" \
      --add-flags "--add-exports=java.desktop/sun.awt=ALL-UNNAMED" \
      --add-flags "--add-exports=java.desktop/sun.java2d=ALL-UNNAMED" \
      --add-flags "-classpath lib/app/netlogo-${finalAttrs.version}.jar org.nlogo.app.App"
    install -Dm644 icons/NetLogo.png $out/share/icons/hicolor/1024x1024/apps/netlogo.png

    runHook postInstall
  '';

  meta = {
    description = "Multi-agent programmable modeling environment";
    mainProgram = "netlogo";
    longDescription = ''
      NetLogo is a multi-agent programmable modeling environment. It is used by
      many tens of thousands of students, teachers and researchers worldwide.
    '';
    homepage = "https://ccl.northwestern.edu/netlogo/index.shtml";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.dpaetzel ];
    platforms = lib.platforms.linux;
  };
})
