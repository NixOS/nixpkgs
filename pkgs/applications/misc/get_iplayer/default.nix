{
  lib,
  perlPackages,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  shortenPerlShebang,
  perl,
  atomicparsley,
  ffmpeg,
}:

perlPackages.buildPerlPackage rec {
  pname = "get_iplayer";
  version = "3.35";

  src = fetchFromGitHub {
    owner = "get-iplayer";
    repo = "get_iplayer";
    rev = "v${version}";
    hash = "sha256-fqzrgmtqy7dlmGEaTXAqpdt9HqZCVooJ0Vf6/JUKihw=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;
  buildInputs = [ perl ];
  propagatedBuildInputs = with perlPackages; [
    LWP
    LWPProtocolHttps
    XMLLibXML
    Mojolicious
  ];

  preConfigure = "touch Makefile.PL";
  doCheck = false;
  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -D get_iplayer -t $out/bin
    wrapProgram $out/bin/get_iplayer --suffix PATH : ${
      lib.makeBinPath [
        atomicparsley
        ffmpeg
      ]
    } --prefix PERL5LIB : $PERL5LIB
    install -Dm444 get_iplayer.1 -t $out/share/man/man1

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/.get_iplayer-wrapped
  '';

  meta = with lib; {
    description = "Downloads TV and radio programmes from BBC iPlayer and BBC Sounds";
    mainProgram = "get_iplayer";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/get-iplayer/get_iplayer";
    platforms = platforms.all;
    maintainers = with maintainers; [
      rika
      chewblacka
    ];
  };

}
