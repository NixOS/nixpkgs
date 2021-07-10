{ lib
, fetchurl
, appimageTools
}:

let
  pname = "dust3d";
  version = "1.0.0-rc.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/huxingyi/dust3d/releases/download/${version}/dust3d-${version}.AppImage";
    sha256 = "035mdm8dg6hknnadh5vc58hkwmzgvq5pp6ysib2n9a65sbgsg7xd";
    name="${name}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/dust3d.desktop $out/share/applications/dust3d.desktop
    install -m 444 -D ${appimageContents}/dust3d.png \
      $out/share/icons/hicolor/250x250/apps/dust3d.png
  '';

  meta = with lib; {
    description = "Cross-platform open-source modeling software";
    homepage = "https://dust3d.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
