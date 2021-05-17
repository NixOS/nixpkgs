{ lib, fetchurl, appimageTools, imagemagick}:

let
  pname = "lens";
  version = "4.2.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/${pname}app/${pname}/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha512 = "a51BIWh5qa98NcF5PVB8ULiVxTprhNJG/iAQZ5ZDHjTMgTnwL3EfjqvvrZn9ybIbme6aTSGRR/tN2pzaZ823Yg==";
  };


  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/lens $out/share/applications/lens.desktop
    install -m 444 -D ${appimageContents}/lens.png $out/share/icons/hicolor/1024x1024/apps/lens.png
    ${imagemagick}/bin/convert ${appimageContents}/lens.png -resize 512x512 lens_512.png
    install -m 444 -D lens_512.png $out/share/icons/hicolor/512x512/apps/lens.png
    substituteInPlace $out/share/applications/lens.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Kubernetes Lens Client";
    homepage = "https://www.k8slens.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ glottologist ];
    platforms = [ "x86_64-linux" ];
  };
}

