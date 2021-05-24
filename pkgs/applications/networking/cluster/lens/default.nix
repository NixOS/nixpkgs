{ lib, fetchurl, appimageTools }:

let
  pname = "lens";
  version = "4.2.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/lensapp/lens/releases/download/v${version}/Lens-${version}.x86_64.AppImage";
    sha256 = "0fzhv8brwwl1ihx6jqq4pi77489hr6f9hpppqq3n8d2imjsqgvlw";
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
