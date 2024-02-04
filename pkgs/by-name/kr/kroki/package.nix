{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jre
, d2
, ditaa
, graphviz
, pikchr
, plantuml
, svgbob
, umlet
}:

let
  version = "0.23.0";
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "kroki";

  src = fetchurl {
    url = "https://github.com/yuzutech/kroki/releases/download/v${version}/kroki-standalone-server-v${version}.jar";
    hash = "sha256-BmjQ9YBxQcLT8NN7HotRHhqWDH1l56ocwZa4r3zPlMg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  # Todo: add missing dependencies
  # https://docs.kroki.io/kroki/setup/configuration/#_diagram_binary_paths
  buildCommand = ''
    install -Dm644 $src $out/lib/kroki.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/kroki \
      --set KROKI_D2_BIN_PATH ${lib.getExe d2} \
      --set KROKI_DITAA_BIN_PATH ${lib.getExe ditaa} \
      --set KROKI_DOT_BIN_PATH ${lib.getBin graphviz}/bin/dot \
      --set KROKI_PIKCHR_BIN_PATH ${lib.getExe pikchr} \
      --set KROKI_PLANTUML_BIN_PATH ${lib.getExe plantuml} \
      --set KROKI_SVGBOB_BIN_PATH ${lib.getExe svgbob} \
      --set KROKI_UMLET_BIN_PATH ${lib.getExe umlet} \
      --add-flags "-jar $out/lib/kroki.jar"

    $out/bin/kroki -help
  '';

  meta = {
    description = "Creates diagrams from textual descriptions";
    homepage = "https://kroki.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
}
