{ lib
, fetchurl
, appimageTools
, symlinkJoin
}:

let
  pname = "runwayml";
  version = "0.14.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://runway-releases.s3.amazonaws.com/Runway-${version}.AppImage";
    sha256 = "1bx8j39wd2z6f32hdvmk9z77bivnizzdhn296kin2nnqgq6v6y93";
  };

  binary = appimageTools.wrapType2 {
    name = pname;
    inherit src;
  };
  # we only use this to extract the icon and desktop file
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
    homepage = "https://runwayml.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
