{ stdenv
, lib
, fetchurl
, makeWrapper
, git
, coreutils
, jdk
, gnuplot
, graphviz
}:
stdenv.mkDerivation rec {
  pname = "maelstrom";
  version = "0.2.4";

  src = fetchurl {
    url = "https://github.com/jepsen-io/maelstrom/releases/download/v${version}/maelstrom.tar.bz2";
    hash = "sha256-MB7HHWsSrw12XttBP1z1qhBGtWCb1OMTdqC1SVSOV5k=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R lib $out/lib

    # see https://github.com/jepsen-io/maelstrom/blob/b91beef83ee40add17dfe0baf2df272869e144cf/pkg/maelstrom
    makeWrapper ${jdk}/bin/java $out/bin/maelstrom \
      --add-flags -Djava.awt.headless=true \
      --add-flags "-jar $out/lib/maelstrom.jar" \
      --set PATH ${lib.makeBinPath runtimeDependencies}

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  runtimeDependencies = [
    git
    coreutils
    jdk
    gnuplot
    graphviz
  ];

  meta = with lib; {
    description = "Workbench for writing toy implementations of distributed systems";
    homepage = "https://github.com/jepsen-io/maelstrom";
    changelog = "https://github.com/jepsen-io/maelstrom/releases/tag/${version}";
    mainProgram = "maelstrom";
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    license = licenses.epl10;
    maintainers = [ maintainers.emilioziniades ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
