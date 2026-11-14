{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  jdk,
  ant,
  stripJavaArchivesHook,
  gtk3,
  gsettings-desktop-schemas,
  p7zip,
  autoPatchelfHook,
  libxxf86vm,
  libGL,
  copyDesktopItems,
  libicns,

  pname,
  version,
  src,
  meta,
  patches,
  passthru,
  enableJava2dOpenGL,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    patches
    passthru
    ;

  desktopItems = [
    (makeDesktopItem {
      name = "sweethome3d";
      desktopName = "Sweet Home 3D";
      icon = "sweethome3d";
      comment = meta.description;
      exec = "${meta.mainProgram} %f";
      mimeTypes = [ "application/x-sweet-home-3d" ];
      startupWMClass = "com-eteks-sweethome3d-SweetHome3DBootstrap";
      genericName = "Computer Aided (Interior) Design";
      categories = [
        "Graphics"
        "2DGraphics"
        "3DGraphics"
      ];
    })
  ];

  postPatch = ''
    rm -r src/com/sm

    addAutoPatchelfSearchPath ${jdk}/lib/openjdk/lib/
    autoPatchelf lib

    # Nix cannot see the runtime references to the paths we just patched in
    # once they've been compressed into the .jar. Scan for and remember them
    # as plain text so they don't get overlooked.
    find . -name '*.so' | xargs strings | { grep '/nix/store' || :; } >> ./.jar-paths
  '';

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    stripJavaArchivesHook
    copyDesktopItems
    libicns
  ];
  buildInputs = [
    ant
    jdk
    p7zip
    gtk3
    gsettings-desktop-schemas
    libxxf86vm
  ];

  # upstream targets Java 7 by default
  env.ANT_ARGS = "-DappletClassSource=8 -DappletClassTarget=8 -DclassSource=8 -DclassTarget=8";

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp install/SweetHome3D-${version}.jar $out/share/java/.
    install -Dm644 ${./sweethome3d-mime.xml} $out/share/mime/packages/sweethome3d.xml

    mkdir icons
    icns2png -x -o icons "install/macosx/Sweet Home 3D/Contents/Resources/SweetHome3D.icns"
    for size in 32 64 128 256 512; do
      install -Dm644 icons/SweetHome3D_''${size}x''${size}x32.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/sweethome3d.png
    done
    install -Dm644 deploy/SweetHome3DIcon48x48.png $out/share/icons/hicolor/48x48/apps/sweethome3d.png

    makeWrapper ${jdk}/bin/java $out/bin/${meta.mainProgram} \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --add-flags "${lib.optionalString enableJava2dOpenGL "-Dsun.java2d.opengl=true "}-Dcom.eteks.sweethome3d.j3d.useOffScreen3DView=true -jar $out/share/java/SweetHome3D-${version}.jar"


    # remember the store paths found inside the .jar libraries. note that
    # which file they are in does not matter in particular, just that some
    # file somewhere lists them in plain-text
    mkdir -p $out/nix-support
    cp .jar-paths $out/nix-support/depends

    runHook postInstall
  '';

  dontStrip = true;
}
