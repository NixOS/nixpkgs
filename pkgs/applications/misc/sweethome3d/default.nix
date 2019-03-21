{ lib, stdenv, fetchurl, fetchsvn, makeWrapper, makeDesktopItem, jdk, jre, ant
, gtk3, gsettings-desktop-schemas, p7zip, libXxf86vm }:

let

  getDesktopFileName = drvName: (builtins.parseDrvName drvName).name;

  # TODO: Should we move this to `lib`? Seems like its would be useful in many cases.
  extensionOf = filePath:
    lib.concatStringsSep "." (lib.tail (lib.splitString "." (builtins.baseNameOf filePath)));

  installIcons = iconName: icons: lib.concatStringsSep "\n" (lib.mapAttrsToList (size: iconFile: ''
    mkdir -p "$out/share/icons/hicolor/${size}/apps"
    ln -s -T "${iconFile}" "$out/share/icons/hicolor/${size}/apps/${iconName}.${extensionOf iconFile}"
  '') icons);

  mkSweetHome3D =
  { name, module, version, src, license, description, desktopName, icons }:

  stdenv.mkDerivation rec {
    inherit name version src description;
    exec = stdenv.lib.toLower module;
    sweethome3dItem = makeDesktopItem {
      inherit exec desktopName;
      name = getDesktopFileName name;
      icon = getDesktopFileName name;
      comment =  description;
      genericName = "Computer Aided (Interior) Design";
      categories = "Application;Graphics;2DGraphics;3DGraphics;";
    };

    patchPhase = ''
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/amd64/libnativewindow_awt.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/amd64/libnativewindow_x11.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/i586/libnativewindow_awt.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/i586/libnativewindow_x11.so
    '';

    buildInputs = [ ant jdk jre makeWrapper p7zip gtk3 gsettings-desktop-schemas ];

    buildPhase = ''
      ant furniture textures help
      mkdir -p $out/share/{java,applications}
      mv "build/"*.jar $out/share/java/.
      ant
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp install/${module}-${version}.jar $out/share/java/.

      ${installIcons (getDesktopFileName name) icons}

      cp "${sweethome3dItem}/share/applications/"* $out/share/applications

      makeWrapper ${jre}/bin/java $out/bin/$exec \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-jar $out/share/java/${module}-${version}.jar -cp $out/share/java/Furniture.jar:$out/share/java/Textures.jar:$out/share/java/Help.jar -d${toString stdenv.hostPlatform.parsed.cpu.bits}"
    '';

    dontStrip = true;

    meta = {
      homepage = http://www.sweethome3d.com/index.jsp;
      inherit description;
      inherit license;
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  d2u = stdenv.lib.replaceChars ["."] ["_"];

in rec {

  application = mkSweetHome3D rec {
    version = "6.0";
    module = "SweetHome3D";
    name = stdenv.lib.toLower module + "-application-" + version;
    description = "Design and visualize your future home";
    license = stdenv.lib.licenses.gpl2Plus;
    src = fetchsvn {
      url = "https://svn.code.sf.net/p/sweethome3d/code/tags/V_" + d2u version + "/SweetHome3D/";
      sha256 = "1l4kc1c2iwkggmcdb2wksb4vrh97ll804vc51yawhdlq9g567ky9";
      rev = "6647";
    };
    desktopName = "Sweet Home 3D";
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
  };

}
