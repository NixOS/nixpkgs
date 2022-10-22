{ stdenv, lib, fetchurl, unzip, makeDesktopItem, copyDesktopItems
, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "indigenous-desktop";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/marksuth/indigenous-desktop/releases/download/v${version}/indigenous-linux-x64-${version}.zip";
    sha256 = "sha256-1nqj9N5RQE0PogJSULu75CTVLHeQsHIimtFXSCP6SPA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    unzip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "indigenous-desktop";
      icon = "indigenous-desktop";
      comment = meta.description;
      desktopName = "Indigenous";
      genericName = "Feed Reader";
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/indigenous $out/share/indigenous $out/share/pixmaps
    cp -r ./ $out/opt/indigenous
    mv $out/opt/indigenous/{locales,resources} $out/share/indigenous
    mv $out/share/indigenous/resources/app/images/icon.png $out/share/pixmaps/indigenous-desktop.png

    makeWrapper ${electron}/bin/electron $out/bin/indigenous-desktop \
      --add-flags $out/share/indigenous/resources/app

    runHook postInstall
  '';

  meta = with lib; {
    description = "IndieWeb app with extensions for sharing to/reading from micropub endpoints";
    homepage = "https://indigenous.realize.be/indigenous-desktop";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
