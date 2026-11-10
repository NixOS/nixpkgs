{
  lib,
  stdenv,
  fetchurl,
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

  pname,
  version,
  src,
  meta,
  patches,
  passthru,
  enableJava2dOpenGL,
}:

let

  # TODO: Should we move this to `lib`? Seems like its would be useful in many cases.
  extensionOf =
    filePath: lib.concatStringsSep "." (lib.tail (lib.splitString "." (baseNameOf filePath)));

  installIcons =
    iconName: icons:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (size: iconFile: ''
        mkdir -p "$out/share/icons/hicolor/${size}/apps"
        ln -s -T "${iconFile}" "$out/share/icons/hicolor/${size}/apps/${iconName}.${extensionOf iconFile}"
      '') icons
    );

  icons = {
    "32x32" = fetchurl {
      url = "http://sweethome3d.cvs.sourceforge.net/viewvc/sweethome3d/SweetHome3D/deploy/SweetHome3DIcon32x32.png";
      sha256 = "1r2fhfg27mx00nfv0qj66rhf719s2g1vhdis7bdc9mqk9x0mb0ir";
    };
    "48x48" = fetchurl {
      url = "http://sweethome3d.cvs.sourceforge.net/viewvc/sweethome3d/SweetHome3D/deploy/SweetHome3DIcon48x48.png";
      sha256 = "1ap6d75dyqqvx21wddvn8vw2apq3v803vmbxdriwd0dw9rq3zn4g";
    };
  };

in
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

    ${installIcons "sweethome3d" icons}

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
