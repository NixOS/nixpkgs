{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemacrawler";
  version = "16.28.3";

  src = fetchzip {
    url = "https://github.com/schemacrawler/SchemaCrawler/releases/download/v${finalAttrs.version}/schemacrawler-${finalAttrs.version}-bin.zip";
    hash = "sha256-OtQYAJe5eHoEis8Azy1LPxJdZR4HlKn8UhlDglqarto=";
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

<<<<<<< HEAD
  meta = {
    description = "Database schema discovery and comprehension tool";
    mainProgram = "schemacrawler";
    homepage = "https://www.schemacrawler.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Database schema discovery and comprehension tool";
    mainProgram = "schemacrawler";
    homepage = "https://www.schemacrawler.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      epl10
      gpl3Only
      lgpl3Only
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
})
