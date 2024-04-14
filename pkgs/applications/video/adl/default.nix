{ lib, stdenv, fetchFromGitHub, pkgs, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "adl";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "RaitaroH";
    repo = "adl";
    rev = "65f68e1dcae4c0caa52668d3a854269e7d226f7c";
    sha256 = "sha256-huGpDtkWrhZyKDNKXat8T3qtAyMjBaq8HFd1w1ThUVk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # https://github.com/RaitaroH/adl#requirements
  buildInputs = with pkgs; [
    anime-downloader
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
    description = "popcorn anime-downloader + trackma wrapper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    mainProgram = "adl";
  };
}
