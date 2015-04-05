{stdenv, fetchurl, flvstreamer, ffmpeg, makeWrapper, perl, buildPerlPackage, perlPackages, vlc, rtmpdump}:
buildPerlPackage {
  name = "get_iplayer-2.92";

  buildInputs = [makeWrapper perl];
  propagatedBuildInputs = with perlPackages; [HTMLParser HTTPCookies LWP];

  preConfigure = "touch Makefile.PL";
  doCheck = false;

  installPhase = '' 
    mkdir -p $out/bin
    cp get_iplayer $out/bin
    sed -i 's|^update_script|#update_script|' $out/bin/get_iplayer
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${ffmpeg}/bin:${flvstreamer}/bin:${vlc}/bin:${rtmpdump}/bin --prefix PERL5LIB : $PERL5LIB
  '';  
  
  src = fetchurl {
    url = ftp://ftp.infradead.org/pub/get_iplayer/get_iplayer-2.92.tar.gz;
    sha256 = "1pg4ay32ykxbnvk9dglwpbfjwhcc4ijfl8va89jzyxicbf7s6077";
  };
  
}
