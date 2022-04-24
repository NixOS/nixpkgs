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
, p7zip
, libXxf86vm
, unzip
}:

let

  # TODO: Should we move this to `lib`? Seems like its would be useful in many cases.
  extensionOf = filePath:
    lib.concatStringsSep "." (lib.tail (lib.splitString "." (builtins.baseNameOf filePath)));

  installIcons = iconName: icons: lib.concatStringsSep "\n" (lib.mapAttrsToList (size: iconFile: ''
    mkdir -p "$out/share/icons/hicolor/${size}/apps"
    ln -s -T "${iconFile}" "$out/share/icons/hicolor/${size}/apps/${iconName}.${extensionOf iconFile}"
  '') icons);

  mkSweetHome3D =
  { pname, module, version, src, license, description, desktopName, icons }:

  stdenv.mkDerivation rec {
    inherit pname version src description;
    exec = lib.toLower module;
    sweethome3dItem = makeDesktopItem {
      inherit exec desktopName;
      name = pname;
      icon = pname;
      comment =  description;
      genericName = "Computer Aided (Interior) Design";
      categories = [ "Graphics" "2DGraphics" "3DGraphics" ];
    };

    postPatch = ''
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/amd64/libnativewindow_awt.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/amd64/libnativewindow_x11.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/i586/libnativewindow_awt.so
      patchelf --set-rpath ${libXxf86vm}/lib lib/java3d-1.6/linux/i586/libnativewindow_x11.so
    '';

    nativeBuildInputs = [ makeWrapper unzip ];
    buildInputs = [ ant jdk8 p7zip gtk3 gsettings-desktop-schemas ];

    buildPhase = ''
      runHook preBuild

      ant furniture textures help
      mkdir -p $out/share/{java,applications}
      mv "build/"*.jar $out/share/java/.
      ant

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp install/${module}-${version}.jar $out/share/java/.

      ${installIcons pname icons}

      cp "${sweethome3dItem}/share/applications/"* $out/share/applications

      # MESA_GL_VERSION_OVERRIDE is needed since the update from MESA 19.3.3 to 20.0.2:
      # without it a "Profiles [GL4bc, GL3bc, GL2, GLES1] not available on device null"
      # exception is thrown on startup.
      # https://discourse.nixos.org/t/glx-not-recognised-after-mesa-update/6753
      makeWrapper ${jre8}/bin/java $out/bin/$exec \
        --set MESA_GL_VERSION_OVERRIDE 2.1 \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-Dsun.java2d.opengl=true -jar $out/share/java/${module}-${version}.jar -cp $out/share/java/Furniture.jar:$out/share/java/Textures.jar:$out/share/java/Help.jar -d${toString stdenv.hostPlatform.parsed.cpu.bits}"

      runHook postInstall
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

  d2u = lib.replaceChars ["."] ["_"];

in {

  application = mkSweetHome3D rec {
    pname = lib.toLower module + "-application";
    version = "6.6";
    module = "SweetHome3D";
    description = "Design and visualize your future home";
    license = lib.licenses.gpl2Plus;
    src = fetchurl {
      url = "mirror://sourceforge/sweethome3d/${module}-${version}-src.zip";
      sha256 = "sha256-CnVXpmodmyoZdqmt7OgRyzuLeDhkPhrAS/CldFM8SQs=";
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
