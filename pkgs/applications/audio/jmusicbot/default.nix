{ stdenv, lib, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "JMusicBot";
  version = "0.3.4";

  src = fetchurl {
    url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
    sha256 = "sha256-++/ot9k74pkN9Wl7IEjiMIv/q5zklIEdU6uFjam0tmU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib
    cp $src $out/lib/JMusicBot

    makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
      --add-flags "-Xmx1G -Dnogui=true -jar $out/lib/JMusicBot"
  '';

  meta = with lib; {
    description = "Discord music bot that's easy to set up and run yourself";
    homepage = "https://github.com/jagrosh/MusicBot";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.all;
  };
}
