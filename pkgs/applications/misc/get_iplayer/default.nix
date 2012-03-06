{stdenv, fetchurl, flvstreamer, ffmpeg, makeWrapper, perl}:

stdenv.mkDerivation {
  name = "get_iplayer-2.80";

  buildInputs = [makeWrapper perl];

  installPhase = '' 
    mkdir -p $out/bin
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH ${ffmpeg}/bin:${flvstreamer}/bin
  '';  
  
  src = fetchurl {
    url = ftp://ftp.infradead.org/pub/get_iplayer/get_iplayer-2.80.tar.gz;
    sha256 = "1hnadryyzca3bv1hfk2q3np9ihwvyxa3prwcrply6ywy4vnayjf8";
  };
  
}
