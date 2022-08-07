{ stdenv, lib, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "JMusicBot";
  version = "0.3.8";

  src = fetchurl {
    url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
    sha256 = "sha256-wzmrh9moY6oo3RqOy9Zl1X70BZlvbJkQmz8BaBIFtIM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib
    cp $src $out/lib/JMusicBot

    makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
      --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/lib/JMusicBot"
  '';

  meta = with lib; {
    description = "Discord music bot that's easy to set up and run yourself";
    homepage = "https://github.com/jagrosh/MusicBot";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.all;
  };
}
