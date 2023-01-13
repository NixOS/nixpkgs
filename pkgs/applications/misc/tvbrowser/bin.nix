{ lib, stdenv, fetchurl, makeWrapper, jre, makeDesktopItem }:

let
  minimalJavaVersion = "11";

  desktopItem = makeDesktopItem {
    name = "tvbrowser";
    exec = "tvbrowser";
    icon = "tvbrowser";
    comment = "Themeable and easy to use TV Guide";
    desktopName = "TV-Browser";
    genericName = "Electronic TV Program Guide";
    categories = [ "AudioVideo" "TV" "Java" ];
    startupNotify = true;
    startupWMClass = "tvbrowser-TVBrowser";
  };

in
assert lib.versionAtLeast jre.version minimalJavaVersion;
stdenv.mkDerivation rec {
  pname = "tvbrowser";
  version = "4.2.7";
  name = "${pname}-bin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/TV-Browser%20Releases%20%28Java%20${minimalJavaVersion}%20and%20higher%29/${version}/${pname}_${version}_bin.tar.gz";
    hash = "sha256-A1ZLGHA1sSSafwWy6MlPikQMk+6CechftzFTLDaBfrs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java/${pname}
    cp -R * $out/share/java/${pname}
    rm $out/share/java/${pname}/${pname}.{sh,desktop}

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    for i in 16 32 48 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      ln -s $out/share/java/${pname}/imgs/${pname}$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "--module-path=lib:${pname}.jar -m ${pname}/tvbrowser.TVBrowser"  \
      --chdir "$out/share/java/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Electronic TV Program Guide";
    homepage = "https://www.tvbrowser.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau yarny ];
  };
}
