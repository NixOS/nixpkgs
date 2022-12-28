{ lib
, stdenv
, fetchurl
, appimageTools
, tor
, trezord
}:

let
  pname = "trezor-suite";
  version = "22.11.1";
  name = "${pname}-${version}";

  suffix = {
    aarch64-linux = "linux-arm64";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/trezor/${pname}/releases/download/v${version}/Trezor-Suite-${version}-${suffix}.AppImage";
    sha512 = { # curl -Lfs https://github.com/trezor/trezor-suite/releases/latest/download/latest-linux{-arm64,}.yml | grep ^sha512 | sed 's/: /-/'
      aarch64-linux = "sha512-cZZFc1Ij7KrF0Kc1Xmtg/73ASv56a6SFWFy3Miwl3P5u8ieZGXVDlSQyv84CsuYMbE0Vga3X0XS/BiF7nKNcnA==";
      x86_64-linux  = "sha512-X/IEZGs43riUn6vC5bPyj4DS/VK+s7C10PbBnvwieaclBSVJyQ8H8hbn4eKi0kMVNEl0A9o8W09gXBxAhdNR9g==";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
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
    install -m 444 -D ${appimageContents}/resources/images/desktop/512x512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'

    # symlink system binaries instead bundled ones
    mkdir -p $out/share/${pname}/resources/bin/{bridge,tor}
    ln -sf ${trezord}/bin/trezord-go $out/share/${pname}/resources/bin/bridge/trezord
    ln -sf ${tor}/bin/tor $out/share/${pname}/resources/bin/tor/tor
  '';

  meta = with lib; {
    description = "Trezor Suite - Desktop App for managing crypto";
    homepage = "https://suite.trezor.io";
    changelog = "https://github.com/trezor/trezor-suite/releases/tag/v${version}";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
