{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemacrawler";
  version = "17.6.0";

  src = fetchzip {
    url = "https://github.com/schemacrawler/SchemaCrawler/releases/download/v${finalAttrs.version}/schemacrawler-${finalAttrs.version}-bin.zip";
    hash = "sha256-GReeCRzYm3tQW6TQWcxx5DeUnROnN0W6mypzWs4wUec=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r {config,lib} $out/

    makeWrapper ${jre}/bin/java $out/bin/schemacrawler \
      --add-flags "-cp $out/lib/*:$out/config" \
      --add-flags schemacrawler.Main

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = {
    description = "Database schema discovery and comprehension tool";
    mainProgram = "schemacrawler";
    homepage = "https://www.schemacrawler.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = with lib.licenses; [
      epl10
      gpl3Only
      lgpl3Only
    ];
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
