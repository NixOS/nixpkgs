{ stdenv, lib, fetchurl, makeWrapper, makeDesktopItem, copyDesktopItems, electron }:

let
  version = "0.13.0";
  appIcon = fetchurl {
    url = "https://raw.githubusercontent.com/Splode/pomotroid/v${version}/static/icon.png";
    sha256 = "sha256-BEPoOBErw5ZCeK4rtdxdwZZLimbpglu1Cu++4xzuVUs=";
  };

in stdenv.mkDerivation rec {
  pname = "pomotroid";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Splode/pomotroid/releases/download/v${version}/${pname}-${version}-linux.tar.gz";
    sha256 = "sha256-AwpVnvwWQd/cgmZvtr5NprnLyeXz6ym4Fywc808tcSc=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "pomotroid";
      icon = "pomotroid";
      comment = meta.description;
      desktopName = "Pomotroid";
      genericName = "Pomodoro Application";
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/pomotroid $out/share/pomotroid $out/share/pixmaps

    cp -r ./ $out/opt/pomotroid
    mv $out/opt/pomotroid/{locales,resources} $out/share/pomotroid
    cp ${appIcon} $out/share/pixmaps/pomotroid.png

    makeWrapper ${electron}/bin/electron $out/bin/pomotroid \
      --add-flags $out/share/pomotroid/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple and visually-pleasing Pomodoro timer";
    homepage = "https://splode.github.io/pomotroid";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
