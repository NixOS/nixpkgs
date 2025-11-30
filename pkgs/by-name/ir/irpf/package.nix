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
  writeScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "irpf";
  version = "2025-1.7";

  # https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
  # Para outros sistemas operacionais -> Multi
  src =
    let
      year = lib.head (lib.splitVersion finalAttrs.version);
    in
    fetchzip {
      url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${finalAttrs.version}.zip";
      hash = "sha256-VLB/Ni+sZ0Xugh3v7vb4rqTlAZz3eHU33lbljCX3Yic=";
    };

  passthru.updateScript = writeScript "update-irpf" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pup common-updater-scripts

    set -eu -o pipefail
    #parses the html with the install links for the containers that contain the instalation files of type 'file archive, gets the version number of each version, and sorts to get the latest one on the website
    version="$(curl -s https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf | pup '.rfb_container .rfb_ositem:parent-of(.fa-file-archive) attr{href}' | grep -oP "IRPF\K(\d+)-[\d.]+\d" | sort -r |  head -1)"
    update-source-version irpf "$version"
  '';

  nativeBuildInputs = [
    unzip
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "irpf";
      exec = "irpf";
      icon = "rfb64";
      desktopName = "Imposto de Renda Pessoa Física";
      comment = "Programa Oficial da Receita para elaboração do IRPF";
      categories = [ "Office" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    BASEDIR="$out/share/irpf"
    mkdir -p "$BASEDIR"

    cp --no-preserve=mode -r help lib lib-modulos "$BASEDIR"

    install -Dm644 irpf.jar Leia-me.htm offline.png online.png pgd-updater.jar "$BASEDIR"

    # make xdg-open overrideable at runtime
    makeWrapper ${jdk11}/bin/java $out/bin/irpf \
      --add-flags "-Dawt.useSystemAAFontSettings=gasp" \
      --add-flags "-Dswing.aatext=true" \
      --add-flags "-jar $BASEDIR/irpf.jar" \
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
    ];
    mainProgram = "irpf";
  };
})
