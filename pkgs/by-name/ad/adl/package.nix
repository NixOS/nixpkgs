{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, animdl
, frece
, fzf
, mpv
, perl
, trackma
, ueberzug
, ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "adl";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "RaitaroH";
    repo = "adl";
    rev = "a40f31454de856d9e9235d6216eaf8f4296111c4";
    hash = "sha256-Kg/iGyEdWJyoPn5lVqRCJX2eqdP1xwZqNU2RvTrhZko=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # https://github.com/RaitaroH/adl#requirements
  buildInputs = [
    animdl
    frece
    fzf
    mpv
    perl
    trackma
    ueberzug
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/adl $out/bin
    wrapProgram $out/bin/adl \
      --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    homepage = "https://github.com/RaitaroH/adl";
    description = "Popcorn anime scraper/downloader + trackma wrapper";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ weathercold ];
    mainProgram = "adl";
  };
}
