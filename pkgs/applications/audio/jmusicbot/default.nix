{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  jre_headless,
}:

stdenv.mkDerivation rec {
  pname = "JMusicBot";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
    sha256 = "sha256-+0814w4zKNr2TxZ9CS8FxeuTLa71jM+DhrfFvLMFlw0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib
    cp $src $out/lib/JMusicBot

    makeWrapper ${jre_headless}/bin/java $out/bin/JMusicBot \
      --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/lib/JMusicBot"
  '';

  meta = with lib; {
    description = "Discord music bot that's easy to set up and run yourself";
    homepage = "https://github.com/jagrosh/MusicBot";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    inherit (jre_headless.meta) platforms;
    mainProgram = "JMusicBot";
  };
}
