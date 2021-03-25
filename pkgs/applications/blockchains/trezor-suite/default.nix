{ lib
, fetchurl
, appimageTools
, tor
, trezord
}:

let
  pname = "trezor-suite";
  version = "21.2.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/trezor/${pname}/releases/download/v${version}/Trezor-Suite-${version}-linux-x86_64.AppImage";
    sha256 = "0dj3azx9jvxchrpm02w6nkcis6wlnc6df04z7xc6f66fwn6r3kkw";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in

appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    mkdir -p $out/bin $out/share/${pname} $out/share/${pname}/resources

    cp -a ${appimageContents}/locales/ $out/share/${pname}
    cp -a ${appimageContents}/resources/app*.* $out/share/${pname}/resources
    cp -a ${appimageContents}/resources/images/ $out/share/${pname}/resources

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    install -m 444 -D ${appimageContents}/resources/images/icons/512x512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/trezor-suite.desktop --replace 'Exec=AppRun' 'Exec=${pname}'

    # symlink system binaries instead bundled ones
    mkdir -p $out/share/${pname}/resources/bin/{bridge,tor}
    ln -sf ${trezord}/bin/trezord-go $out/share/${pname}/resources/bin/bridge/trezord
    ln -sf ${tor}/bin/tor $out/share/${pname}/resources/bin/tor/tor
  '';

  meta = with lib; {
    description = "Trezor Suite - Desktop App for managing crypto";
    homepage = "https://suite.trezor.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
