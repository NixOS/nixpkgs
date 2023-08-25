{ lib
, perlPackages
, fetchFromGitHub
, makeWrapper
, stdenv
, shortenPerlShebang
, perl
, atomicparsley
, ffmpeg
, flvstreamer
, rtmpdump
}:

perlPackages.buildPerlPackage rec {
  pname = "get_iplayer";
  version = "3.31";

  src = fetchFromGitHub {
    owner = "get-iplayer";
    repo = "get_iplayer";
    rev = "v${version}";
    sha256 = "+ChCF27nmPKbqaZVxsZ6TlbzSdEz6RfMs87NE8xaSRw=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;
  buildInputs = [ perl ];
  propagatedBuildInputs = with perlPackages; [
    HTMLParser HTTPCookies LWP LWPProtocolHttps XMLLibXML XMLSimple Mojolicious
  ];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [ "out" "man" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${lib.makeBinPath [ atomicparsley ffmpeg flvstreamer rtmpdump ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/.get_iplayer-wrapped
  '';

  meta = with lib; {
    description = "Downloads TV and radio from BBC iPlayer";
    license = licenses.gpl3Plus;
    homepage = "https://squarepenguin.co.uk/";
    platforms = platforms.all;
    maintainers = with maintainers; [ rika jgarcia ];
  };

}
