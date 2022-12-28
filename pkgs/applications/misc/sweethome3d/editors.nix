{ lib
, stdenv
, fetchurl
, makeWrapper
, makeDesktopItem
# sweethome3d 6.5.2 does not yet fully build&run with jdk 9 and later?
, jdk8
, jre8
, ant
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

  applicationSrc = stdenv.mkDerivation {
    name = "application-src";
    src = sweethome3dApp.src;
    nativeBuildInputs = [ unzip ];
    buildPhase = "";
    installPhase = "cp -r . $out";
  };

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

    nativeBuildInputs = [ makeWrapper unzip ];
    buildInputs = [ ant jre8 jdk8 gtk3 gsettings-desktop-schemas ];

    postPatch = ''
      sed -i -e 's,../SweetHome3D,${applicationSrc},g' build.xml
      sed -i -e 's,lib/macosx/java3d-1.6/jogl-all.jar,lib/java3d-1.6/jogl-all.jar,g' build.xml
    '';

    buildPhase = ''
      runHook preBuild

      ant -lib ${applicationSrc}/libtest -lib ${applicationSrc}/lib -lib ${jdk8}/lib

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/{java,applications}
      cp ${module}-${version}.jar $out/share/java/.
      cp "${editorItem}/share/applications/"* $out/share/applications
      makeWrapper ${jre8}/bin/java $out/bin/$exec \
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
    src = fetchurl {
      url = "mirror://sourceforge/sweethome3d/${module}-${version}-src.zip";
      sha256 = "03vb9y645qzffxxdhgbjb0d98k3lafxckg2vh2s86j62b6357d0h";
    };
    desktopName = "Sweet Home 3D - Textures Library Editor";
  };

  furniture-editor = mkEditorProject rec {
    version = "1.28";
    module = "FurnitureLibraryEditor";
    pname = module;
    description = "Quickly create SH3F files and edit the properties of the 3D models it contain";
    license = lib.licenses.gpl2;
    src = fetchurl {
      url = "mirror://sourceforge/sweethome3d/${module}-${version}-src.zip";
      sha256 = "sha256-r5xJlUctUdcknJfm8rbz+bdzFhqgHsHpHwxEC4mItws=";
    };
    desktopName = "Sweet Home 3D - Furniture Library Editor";
  };

}
