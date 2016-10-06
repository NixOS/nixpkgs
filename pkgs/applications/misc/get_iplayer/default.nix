{stdenv, fetchurl, atomicparsley, flvstreamer, ffmpeg, makeWrapper, perl, buildPerlPackage, perlPackages, rtmpdump}:
buildPerlPackage rec {
  name = "get_iplayer-${version}";
  version = "2.97";

  buildInputs = [makeWrapper perl];
  propagatedBuildInputs = with perlPackages; [HTMLParser HTTPCookies LWP XMLLibXML XMLSimple];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [ "out" "man" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${stdenv.lib.makeBinPath [ atomicparsley ffmpeg flvstreamer rtmpdump ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
  '';
  
  src = fetchurl {
    url = "https://github.com/get-iplayer/get_iplayer/archive/v${version}.tar.gz";
    sha256 = "0bb6kmzjmazwfxq5ip7yxm39vssfgz3v5vfx1114wfssp6pw0r44";
  };

  meta = {
    description = "Downloads TV and radio from BBC iPlayer";
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = https://squarepenguin.co.uk/;
    downloadPage = https://github.com/get-iplayer/get_iplayer/releases;
    platforms = stdenv.lib.platforms.all;
  };
  
}
