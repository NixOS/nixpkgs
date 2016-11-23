{ fetchurl, stdenv, lib, undmg }:

stdenv.mkDerivation rec {
  version = "1.0.42.151.g19de0aa6";
  name = "spotify-mac";

  src = fetchurl {
    url = "http://download.spotify.com/Spotify.dmg";
    sha256 = "0fxfibw465mm7p90da53n1ss7hxjk9vp2dfg56wamzyag77xxpqx";
  };

  nativeBuildInputs = [ undmg ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -r . $out/Applications/Spotify.app
  '';

  meta = with lib; {
    homepage = https://www.spotify.com/;
    description = "Play music from the Spotify music service";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
    platforms = platforms.darwin;
  };
}
