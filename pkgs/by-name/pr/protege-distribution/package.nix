{
  lib,
  stdenv,
  fetchurl,
  unzip,
  jdk11,
  copyDesktopItems,
  iconConvTools,
  makeDesktopItem,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "protege-distribution";
  version = "5.6.3";

  src = fetchurl {
    url = "https://github.com/protegeproject/protege-distribution/releases/download/protege-${version}/Protege-${version}-platform-independent.zip";
    sha256 = "08pr0rn76wcc9bczdf93nlshxbid4z4nyvmaz198hhlq96aqpc3i";
  };

  nativeBuildInputs = [
    copyDesktopItems
    iconConvTools
    jdk11
    makeWrapper
    unzip
  ];

  patches = [
    # Replace logic for searching the install directory with a static cd into $out
    ./static-path.patch
    # Disable console logging, maintaining only file-based logging
    ./disable-console-log.patch
  ];

  postPatch = ''
    # Resolve @out@ (introduced by "static-path.patch") to $out
    substituteInPlace run.sh --subst-var-by out $out
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # Wrap launch script to set $JAVA_HOME correctly
    mv run.sh $out/bin/run-protege
    wrapProgram  $out/bin/run-protege --set JAVA_HOME ${jdk11.home}

    # Generate and copy icons to where they can be found
    icoFileToHiColorTheme app/Protege.ico protege $out

    # Move everything else under protege/
    mkdir $out/protege
    mv {bundles,conf,plugins} $out/protege

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Protege";
      desktopName = "Protege Desktop";
      icon = "protege";
      comment = "OWL2 ontology editor";
      categories = [ "Development" ];
      exec = "run-protege";
    })
  ];

  meta = with lib; {
    description = "OWL2 ontology editor from Stanford, with third-party plugins included";
    homepage = "https://protege.stanford.edu/";
    downloadPage = "https://protege.stanford.edu/products.php#desktop-protege";
    maintainers = with maintainers; [ nessdoor ];
    license = with licenses; [
      asl20
      bsd2
      epl10
      lgpl3
    ];
    platforms = platforms.linux;
    mainProgram = "run-protege";
  };
}
