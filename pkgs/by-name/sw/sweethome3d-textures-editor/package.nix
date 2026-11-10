{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  jdk,
  ant,
  stripJavaArchivesHook,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  sweethome3d,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "TexturesLibraryEditor";
  version = "2.1";

  src = fetchzip {
    url = "mirror://sourceforge/sweethome3d/TexturesLibraryEditor-${finalAttrs.version}-src.zip";
    hash = "sha256-pZTVAS0wo0N9Rlu8ud6B1GXINhBQBYhTdxlodRqvk34=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    ant
    glib
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];
  buildInputs = [
    gtk3
    gsettings-desktop-schemas
  ];

  # upstream targets Java 7 by default
  env.ANT_ARGS = "-DappletClassSource=8 -DappletClassTarget=8 -DclassSource=8 -DclassTarget=8";

  postPatch = ''
    sed -i -e 's,../SweetHome3D,${sweethome3d.src},g' build.xml
    sed -i -e 's,lib/macosx/java3d-1.6/jogl-all.jar,lib/java3d-1.6/jogl-all.jar,g' build.xml
  '';

  buildPhase = ''
    runHook preBuild

    ant -lib ${sweethome3d.src}/libtest -lib ${sweethome3d.src}/lib -lib ${jdk}/lib

    runHook postBuild
  '';

  desktopItem = makeDesktopItem {
    name = finalAttrs.pname;
    exec = finalAttrs.meta.mainProgram;
    desktopName = "Sweet Home 3D - Textures Library Editor";
    comment = finalAttrs.meta.description;
    genericName = "Computer Aided (Interior) Design";
    categories = [
      "Graphics"
      "2DGraphics"
      "3DGraphics"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/{java,applications}
    cp TexturesLibraryEditor-${finalAttrs.version}.jar $out/share/java/.
    cp "${finalAttrs.desktopItem}/share/applications/"* $out/share/applications
    makeWrapper ${jdk}/bin/java $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-jar $out/share/java/TexturesLibraryEditor-${finalAttrs.version}.jar -d${toString stdenv.hostPlatform.parsed.cpu.bits}"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    homepage = "https://www.sweethome3d.com/index.jsp";
    description = "Easily create SH3T files and edit the properties of the texture images it contain";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.edwtjo ];
    platforms = lib.platforms.linux;
    mainProgram = "sweethome3d-textures-editor";
  };
})
