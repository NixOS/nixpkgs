{stdenv, fetchurl, flvstreamer, ffmpeg, makeWrapper, perl, buildPerlPackage, perlPackages, vlc, rtmpdump}:
buildPerlPackage {
  name = "get_iplayer-2.83";

  buildInputs = [makeWrapper perl];
  propagatedBuildInputs = with perlPackages; [HTMLParser HTTPCookies LWP];

  preConfigure = "touch Makefile.PL";
  doCheck = false;

  installPhase = '' 
    mkdir -p $out/bin
    cp get_iplayer $out/bin
    sed -i 's|^update_script|#update_script|' $out/bin/get_iplayer
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${ffmpeg}/bin:${flvstreamer}/bin:${vlc}/bin:${rtmpdump}/bin
  '';  
  
  src = fetchurl {
    url = ftp://ftp.infradead.org/pub/get_iplayer/get_iplayer-2.83.tar.gz;
    sha256 = "169zji0rr3z5ng6r4cyzvs89779m4iklln9gsqpryvm81ipalfga";
  };
  
}
