{ stdenv, fetchurl, fetchcvs, makeWrapper, makeDesktopItem, jdk, jre, ant
, p7zip, sweethome3dApp }:

let

  sweetExec = with stdenv.lib;
    m: "sweethome3d-"
    + removeSuffix "libraryeditor" (toLower m)
    + "-editor";
  sweetName = m: v: sweetExec m + "-" + v;

  mkEditorProject =
  { name, module, version, src, license, description }:

  stdenv.mkDerivation rec {
    application = sweethome3dApp;
    inherit name module version src description;
    exec = sweetExec module;
    editorItem = makeDesktopItem {
      inherit name exec;
      comment =  description;
      desktopName = name;
      genericName = "Computer Aided (Interior) Design";
      categories = "Application;CAD;";
    };

    buildInputs = [ ant jre jdk makeWrapper ];

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
      cp ${editorItem}/share/applications/* $out/share/applications
      makeWrapper ${jre}/bin/java $out/bin/$exec \
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

in rec {

  textures-editor = mkEditorProject rec {
    version = "1.3";
    module = "TexturesLibraryEditor";
    name = sweetName module version;
    description = "Easily create SH3T files and edit the properties of the texture images it contain";
    license = stdenv.lib.licenses.gpl2Plus;
    src = fetchcvs {
      cvsRoot = ":pserver:anonymous@sweethome3d.cvs.sourceforge.net:/cvsroot/sweethome3d";
      sha256 = "1caf1hmf87bj5dr7w2swnlbvkb3q1jdjr1zgjn1k07d0fxh0ikbx";
      module = module;
      tag = "V_" + d2u version;
    };
  };

  furniture-editor = mkEditorProject rec {
    version = "1.13";
    module = "FurnitureLibraryEditor";
    name = sweetName module version;
    description = "Quickly create SH3F files and edit the properties of the 3D models it contain";
    license = stdenv.lib.licenses.gpl2;
    src = fetchcvs {
      cvsRoot = ":pserver:anonymous@sweethome3d.cvs.sourceforge.net:/cvsroot/sweethome3d";
      sha256 = "1nll5589rc0g71zd86cwmzl4p2icynykj106schmxric9v17jbv5";
      module = module;
      tag = "V_" + d2u version;
    };
  };

}
