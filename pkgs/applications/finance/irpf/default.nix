{ lib
, stdenvNoCC
, fetchzip
, copyDesktopItems
, jdk11
, makeDesktopItem
, makeWrapper
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "irpf";
  version = "2022-1.0";

  src = let
    year = lib.head (lib.splitVersion version);
  in fetchzip {
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
    sha256 = "0h8f51ilvg7m6hlx0y5mpxhac90p32ksbrffw0hxdqbilgjz1s68";
  };

  nativeBuildInputs = [ unzip makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem rec {
      name = pname;
      exec = pname;
      icon = "rfb64";
      desktopName = "Imposto de Renda Pessoa Física";
      comment = "Programa Oficial da Receita para elaboração do IRPF";
      categories = [ "Office" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    BASEDIR="$out/share/${pname}"
    mkdir -p "$BASEDIR"

    cp -r help lib lib-modulos "$BASEDIR"

    install -Dm755 irpf.jar "$BASEDIR/${pname}.jar"
    install -Dm644 Leia-me.htm offline.png online.png pgd-updater.jar "$BASEDIR"

    makeWrapper ${jdk11}/bin/java $out/bin/${pname} \
      --add-flags "-Dawt.useSystemAAFontSettings=on" \
      --add-flags "-Dswing.aatext=true" \
      --add-flags "-jar $BASEDIR/${pname}.jar" \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set AWT_TOOLKIT MToolkit

    mkdir -p $out/share/pixmaps
    unzip -j lib/ppgd-icones-4.0.jar icones/rfb64.png -d $out/share/pixmaps

    runHook postInstall
  '';

  meta = with lib; {
    description = "Programa Oficial da Receita para elaboração do IRPF";
    homepage = "https://www.gov.br/receitafederal/pt-br";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ atila ];
  };
}
