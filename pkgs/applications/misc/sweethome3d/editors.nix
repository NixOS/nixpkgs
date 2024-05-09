{ lib
, stdenv
, fetchzip
, makeWrapper
, makeDesktopItem
, jdk
, ant
, stripJavaArchivesHook
, gtk3
, gsettings-desktop-schemas
, sweethome3dApp
, unzip
}:

let

  sweetExec = with lib;
    m: "sweethome3d-"
    + removeSuffix "libraryeditor" (toLower m)
    + "-editor";

  mkEditorProject =
  { pname, module, version, src, license, description, desktopName }:

  stdenv.mkDerivation rec {
    application = sweethome3dApp;
    inherit pname module version src description;
    exec = sweetExec module;
    editorItem = makeDesktopItem {
      inherit exec desktopName;
      name = pname;
      comment =  description;
      genericName = "Computer Aided (Interior) Design";
      categories = [ "Graphics" "2DGraphics" "3DGraphics" ];
    };

    nativeBuildInputs = [ makeWrapper stripJavaArchivesHook ];
    buildInputs = [ ant jdk gtk3 gsettings-desktop-schemas ];

    # upstream targets Java 7 by default
    env.ANT_ARGS = "-DappletClassSource=8 -DappletClassTarget=8 -DclassSource=8 -DclassTarget=8";

    postPatch = ''
      sed -i -e 's,../SweetHome3D,${sweethome3dApp.src},g' build.xml
      sed -i -e 's,lib/macosx/java3d-1.6/jogl-all.jar,lib/java3d-1.6/jogl-all.jar,g' build.xml
    '';

    buildPhase = ''
      runHook preBuild

      ant -lib ${sweethome3dApp.src}/libtest -lib ${sweethome3dApp.src}/lib -lib ${jdk}/lib

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/{java,applications}
      cp ${module}-${version}.jar $out/share/java/.
      cp "${editorItem}/share/applications/"* $out/share/applications
      makeWrapper ${jdk}/bin/java $out/bin/$exec \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-jar $out/share/java/${module}-${version}.jar -d${toString stdenv.hostPlatform.parsed.cpu.bits}"
    '';

    dontStrip = true;

    meta = {
      homepage = "http://www.sweethome3d.com/index.jsp";
      inherit description;
      inherit license;
      maintainers = [ lib.maintainers.edwtjo ];
      platforms = lib.platforms.linux;
      mainProgram = exec;
    };

  };

  d2u = lib.replaceStrings ["."] ["_"];

in {

  textures-editor = mkEditorProject rec {
    version = "1.7";
    module = "TexturesLibraryEditor";
    pname = module;
    description = "Easily create SH3T files and edit the properties of the texture images it contain";
    license = lib.licenses.gpl2Plus;
    src = fetchzip {
      url = "mirror://sourceforge/sweethome3d/${module}-${version}-src.zip";
      hash = "sha256-v8hMEUujTgWvFnBTF8Dnd1iWgoIXBzGMUxBgmjdxx+g=";
    };
    desktopName = "Sweet Home 3D - Textures Library Editor";
  };

  furniture-editor = mkEditorProject rec {
    version = "1.28";
    module = "FurnitureLibraryEditor";
    pname = module;
    description = "Quickly create SH3F files and edit the properties of the 3D models it contain";
    license = lib.licenses.gpl2Plus;
    src = fetchzip {
      url = "mirror://sourceforge/sweethome3d/${module}-${version}-src.zip";
      hash = "sha256-pqsSxQPzsyx4PS98fgU6UFhPWhpQoepGm0uJtkvV46c=";
    };
    desktopName = "Sweet Home 3D - Furniture Library Editor";
  };

}
