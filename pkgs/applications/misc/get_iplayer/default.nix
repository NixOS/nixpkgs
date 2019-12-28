{stdenv, fetchFromGitHub, atomicparsley, flvstreamer, ffmpeg, makeWrapper, perl, perlPackages, rtmpdump}:

with stdenv.lib;

perlPackages.buildPerlPackage rec {
  pname = "get_iplayer";
  version = "3.24";

  src = fetchFromGitHub {
    owner = "get-iplayer";
    repo = "get_iplayer";
    rev = "v${version}";
    sha256 = "0yd84ncb6cjrk4v4kz3zrddkl7iwkm3zlfbjyswd9hanp8fvd4q3";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];
  propagatedBuildInputs = with perlPackages; [
    HTMLParser HTTPCookies LWP LWPProtocolHttps XMLLibXML XMLSimple
  ];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [ "out" "man" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${makeBinPath [ atomicparsley ffmpeg flvstreamer rtmpdump ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
  '';

  meta = {
    description = "Downloads TV and radio from BBC iPlayer";
    license = licenses.gpl3Plus;
    homepage = https://squarepenguin.co.uk/;
    platforms = platforms.all;
    maintainers = with maintainers; [ rika ];
  };

}
