{ stdenv, fetchurl, fetchcvs, makeWrapper, makeDesktopItem, jdk, jre, ant
, gtk3, gsettings_desktop_schemas, p7zip, sweethome3dApp }:

let

  sweetExec = with stdenv.lib;
    m: "sweethome3d-"
    + removeSuffix "libraryeditor" (toLower m)
    + "-editor";
  sweetName = m: v: sweetExec m + "-" + v;

  getDesktopFileName = drvName: (builtins.parseDrvName drvName).name;

  mkEditorProject =
  { name, module, version, src, license, description, desktopName }:

  stdenv.mkDerivation rec {
    application = sweethome3dApp;
    inherit name module version src description;
    exec = sweetExec module;
    editorItem = makeDesktopItem {
      inherit exec desktopName;
      name = getDesktopFileName name;
      comment =  description;
      genericName = "Computer Aided (Interior) Design";
      categories = "Application;Graphics;2DGraphics;3DGraphics;";
    };

    buildInputs = [ ant jre jdk makeWrapper gtk3 gsettings_desktop_schemas ];

    patchPhase = ''
      sed -i -e 's,../SweetHome3D,${application.src},g' build.xml
    '';

    buildPhase = ''
      ant -lib ${application.src}/libtest -lib ${application.src}/lib -lib ${jdk}/lib
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/{java,applications}
      cp ${module}-${version}.jar $out/share/java/.
      cp "${editorItem}/share/applications/"* $out/share/applications
      makeWrapper ${jre}/bin/java $out/bin/$exec \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${gsettings_desktop_schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-jar $out/share/java/${module}-${version}.jar ${if stdenv.system == "x86_64-linux" then "-d64" else "-d32"}"
    '';

    dontStrip = true;

    meta = {
      homepage = "http://www.sweethome3d.com/index.jsp";
      inherit description;
      inherit license;
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
      platforms = stdenv.lib.platforms.linux;
    };

  };

  d2u = stdenv.lib.replaceChars ["."] ["_"];

in {

  textures-editor = mkEditorProject rec {
    version = "1.5";
    module = "TexturesLibraryEditor";
    name = sweetName module version;
    description = "Easily create SH3T files and edit the properties of the texture images it contain";
    license = stdenv.lib.licenses.gpl2Plus;
    src = fetchcvs {
      cvsRoot = ":pserver:anonymous@sweethome3d.cvs.sourceforge.net:/cvsroot/sweethome3d";
      sha256 = "15wxdns3hc8yq362x0rj53bcxran2iynxznfcb9js85psd94zq7h";
      module = module;
      tag = "V_" + d2u version;
    };
    desktopName = "Sweet Home 3D - Textures Library Editor";
  };

  furniture-editor = mkEditorProject rec {
    version = "1.19";
    module = "FurnitureLibraryEditor";
    name = sweetName module version;
    description = "Quickly create SH3F files and edit the properties of the 3D models it contain";
    license = stdenv.lib.licenses.gpl2;
    src = fetchcvs {
      cvsRoot = ":pserver:anonymous@sweethome3d.cvs.sourceforge.net:/cvsroot/sweethome3d";
      sha256 = "0rr4nqil1mngak3ds5vz7f1whrgcgzpk6fb0qcr5ljms0jx0ylvs";
      module = module;
      tag = "V_" + d2u version;
    };
    desktopName = "Sweet Home 3D - Furniture Library Editor";
  };

}
