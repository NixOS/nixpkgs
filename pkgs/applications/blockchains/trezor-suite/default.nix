{ lib
, stdenv
, fetchurl
, appimageTools
, tor
, trezord
}:

let
  pname = "trezor-suite";
  version = "24.7.2";

  suffix = {
    aarch64-linux = "linux-arm64";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/trezor/trezor-suite/releases/download/v${version}/Trezor-Suite-${version}-${suffix}.AppImage";
    hash = { # curl -Lfs https://github.com/trezor/trezor-suite/releases/download/v${version}/latest-linux{-arm64,}.yml | grep ^sha512 | sed 's/: /-/'
      aarch64-linux = "sha512-RYkRav7U7WUbZuSvwuWf+IvKgkpUYrclW5vzINcVp/Wzqj3Brl0Cb1fC4dFe7c/UyE/K1oQ4++zd2dHJu6gxEQ==";
      x86_64-linux  = "sha512-WmdH3IC+9tbSLtQirmawi6vgtR7GoFceN2FdZ94rGtCkrvhi9STz5RHfZAljyQfRZ9Xx+DlTChZrsWA6DNqBpg==";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in

appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
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
    mainProgram = "trezor-suite";
  };
}
