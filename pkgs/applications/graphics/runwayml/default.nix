{ lib
, fetchurl
, appimageTools
, symlinkJoin
}:

let
  pname = "runwayml";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://runway-releases.s3.amazonaws.com/Runway%20${version}.AppImage";
    sha256 = "0rg7ipp7kx0l4qgcymfg5d3saz0c6d2j0c6rf28rwqgbm92gbjjq";
    name="${pname}-${version}.AppImage";
  };

  binary = appimageTools.wrapType2 {
    name = "${pname}";
    inherit src;
  };
  # we only use this to extract the icon
  appimage-contents = appimageTools.extractType2 {
    inherit name src;
  };

in
  symlinkJoin {
    inherit name;
    paths = [ binary ];

    postBuild = ''
      mkdir -p $out/share/pixmaps/ $out/share/applications
      cp ${appimage-contents}/usr/share/icons/hicolor/1024x1024/apps/runway.png $out/share/pixmaps/runway.png
      sed 's:Exec=AppRun:Exec=runwayml:' ${appimage-contents}/runway.desktop > $out/share/applications/runway.desktop
    '';

  meta = with lib; {
    description = "Machine learning for creators";
    homepage = https://runwayml.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
