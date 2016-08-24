{stdenv, fetchurl, flvstreamer, ffmpeg, makeWrapper, perl, buildPerlPackage, perlPackages, vlc, rtmpdump}:
buildPerlPackage {
  name = "get_iplayer-2.94";

  buildInputs = [makeWrapper perl];
  propagatedBuildInputs = with perlPackages; [HTMLParser HTTPCookies LWP XMLSimple];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [ "out" "man" ];

  patchPhase = ''
    sed -e 's|^update_script|#update_script|' \
        -e '/WARNING.*updater/d' \
        -i get_iplayer
  '';

  installPhase = '' 
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${stdenv.lib.makeBinPath [ ffmpeg flvstreamer vlc rtmpdump ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
  '';
  
  src = fetchurl {
    url = ftp://ftp.infradead.org/pub/get_iplayer/get_iplayer-2.94.tar.gz;
    sha256 = "16p0bw879fl8cs6rp37g1hgrcai771z6rcqk2nvm49kk39dx1zi4";
  };
  
}
