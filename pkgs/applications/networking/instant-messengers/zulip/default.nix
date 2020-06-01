{ lib
, fetchurl
, appimageTools
}:

let
  pname = "zulip";
  version = "5.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-x86_64.AppImage";
    sha256 = "0rgvllm1pzg6smyjrhh8v1ial0dvav0h2zccxp4p5nqmq6zdvs3h";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/zulip.desktop $out/share/applications/zulip.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zulip.png \
      $out/share/icons/hicolor/512x512/apps/zulip.png
    substituteInPlace $out/share/applications/zulip.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulipchat.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonafato ];
    platforms = [ "x86_64-linux" ];
  };
}
