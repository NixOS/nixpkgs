{ lib, fetchurl, appimageTools }:

let
  pname = "lens";
  version = "3.6.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/lensapp/lens/releases/download/v${version}/Lens-${version}.AppImage";
    sha256 = "0var7d31ab6lq2vq6brk2dnhlnhqjp2gdqhygif567cdmcpn4vz8";
    name="${pname}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands =
    ''
      mv $out/bin/${name} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/kontena-lens.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/kontena-lens.png \
        $out/share/icons/hicolor/512x512/apps/${pname}.png

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Icon=kontena-lens' 'Icon=${pname}' \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "x86_64-linux" ];
  };
}
