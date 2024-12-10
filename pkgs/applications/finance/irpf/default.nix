{
  lib,
  stdenvNoCC,
  fetchzip,
  copyDesktopItems,
  jdk11,
  makeDesktopItem,
  makeWrapper,
  unzip,
  xdg-utils,
}:

stdenvNoCC.mkDerivation rec {
  pname = "irpf";
  version = "2024-1.1";

  # https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
  # Para outros sistemas operacionais -> Multi
  src =
    let
      year = lib.head (lib.splitVersion version);
    in
    fetchzip {
      url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
      hash = "sha256-7Eh5XhZKs2DAQC33ICUG+mgjEU7H3jdYZSeiHNJ6I6Q=";
    };

  nativeBuildInputs = [
    unzip
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
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

    cp --no-preserve=mode -r help lib lib-modulos "$BASEDIR"

    install -Dm644 irpf.jar Leia-me.htm offline.png online.png pgd-updater.jar "$BASEDIR"

    # make xdg-open overrideable at runtime
    makeWrapper ${jdk11}/bin/java $out/bin/${pname} \
      --add-flags "-Dawt.useSystemAAFontSettings=on" \
      --add-flags "-Dswing.aatext=true" \
      --add-flags "-jar $BASEDIR/${pname}.jar" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set AWT_TOOLKIT MToolkit

    mkdir -p $out/share/pixmaps
    unzip -j lib/ppgd-icones-4.0.jar icones/rfb64.png -d $out/share/pixmaps

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brazillian government application for reporting income tax";
    longDescription = ''
      Brazillian government application for reporting income tax.

      IRFP - Imposto de Renda Pessoa Física - Receita Federal do Brasil.
    '';
    homepage = "https://www.gov.br/receitafederal/pt-br";
    license = licenses.unfree;
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [
      atila
      bryanasdev000
    ];
    mainProgram = "irpf";
  };
}
