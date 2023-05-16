<<<<<<< HEAD
{ lib
, perlPackages
, fetchFromGitHub
, makeWrapper
, stdenv
, shortenPerlShebang
, perl
, atomicparsley
, ffmpeg
}:
=======
{ lib, fetchFromGitHub, atomicparsley, flvstreamer, ffmpeg, makeWrapper, perl, perlPackages, rtmpdump}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

perlPackages.buildPerlPackage rec {
  pname = "get_iplayer";
  version = "3.31";

  src = fetchFromGitHub {
    owner = "get-iplayer";
    repo = "get_iplayer";
    rev = "v${version}";
    sha256 = "+ChCF27nmPKbqaZVxsZ6TlbzSdEz6RfMs87NE8xaSRw=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;
  buildInputs = [ perl ];
  propagatedBuildInputs = with perlPackages; [
    LWP LWPProtocolHttps XMLLibXML Mojolicious
=======
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];
  propagatedBuildInputs = with perlPackages; [
    HTMLParser HTTPCookies LWP LWPProtocolHttps XMLLibXML XMLSimple Mojolicious
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [ "out" "man" ];

  installPhase = ''
<<<<<<< HEAD
    runHook preInstall
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${lib.makeBinPath [ atomicparsley ffmpeg ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/.get_iplayer-wrapped
  '';

  meta = with lib; {
    description = "Downloads TV and radio programmes from BBC iPlayer and BBC Sounds";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/get-iplayer/get_iplayer";
    platforms = platforms.all;
    maintainers = with maintainers; [ rika jgarcia ];
=======
    mkdir -p $out/bin $out/share/man/man1
    cp get_iplayer $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${lib.makeBinPath [ atomicparsley ffmpeg flvstreamer rtmpdump ]} --prefix PERL5LIB : $PERL5LIB
    cp get_iplayer.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "Downloads TV and radio from BBC iPlayer";
    license = licenses.gpl3Plus;
    homepage = "https://squarepenguin.co.uk/";
    platforms = platforms.all;
    maintainers = with maintainers; [ rika ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

}
