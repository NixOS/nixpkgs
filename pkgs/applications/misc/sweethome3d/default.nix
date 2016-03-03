{ stdenv, fetchurl, fetchcvs, makeWrapper, makeDesktopItem, jdk, jre, ant
, gtk3, gsettings_desktop_schemas, p7zip }:

let

  mkSweetHome3D =
  { name, module, version, src, license, description, icon }:

  stdenv.mkDerivation rec {
    inherit name version src description icon;
    exec = stdenv.lib.toLower module;
    sweethome3dItem = makeDesktopItem {
      inherit name exec icon;
      comment =  description;
      desktopName = name;
      genericName = "Computer Aided (Interior) Design";
      categories = "Application;CAD;";
    };

    buildInputs = [ ant jdk jre makeWrapper p7zip gtk3 gsettings_desktop_schemas ];

    buildPhase = ''
      ant furniture textures help
      mkdir -p $out/share/{java,applications}
      mv "build/"*.jar $out/share/java/.
      ant
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp install/${module}-${version}.jar $out/share/java/.
      cp "${sweethome3dItem}/share/applications/"* $out/share/applications
      makeWrapper ${jre}/bin/java $out/bin/$exec \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${gsettings_desktop_schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-jar $out/share/java/${module}-${version}.jar -cp $out/share/java/Furniture.jar:$out/share/java/Textures.jar:$out/share/java/Help.jar ${if stdenv.system == "x86_64-linux" then "-d64" else "-d32"}"
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

  application = mkSweetHome3D rec {
    version = "5.2";
    module = "SweetHome3D";
    name = stdenv.lib.toLower module + "-application-" + version;
    description = "Design and visualize your future home";
    license = stdenv.lib.licenses.gpl2Plus;
    src = fetchcvs {
      cvsRoot = ":pserver:anonymous@sweethome3d.cvs.sourceforge.net:/cvsroot/sweethome3d";
      sha256 = "0vws3lj5lgix5fz2hpqvz6p79py5gbfpkhmqpfb1knx1a12310bb";
      module = module;
      tag = "V_" + d2u version;
    };
    icon = fetchurl {
      url = "http://sweethome3d.cvs.sourceforge.net/viewvc/sweethome3d/SweetHome3D/src/com/eteks/sweethome3d/viewcontroller/resources/help/images/sweethome3d.png";
      sha256 = "0lnv2sz2d3m8jx25hz92gzardf0iblykhy5q0q2cyb7mw2qb2p92";
    };
  };

}
