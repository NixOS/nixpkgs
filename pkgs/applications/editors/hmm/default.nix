{ stdenv
, lib
, makeWrapper
, php
, ncurses
, coreutils
, xclip
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "h-m-m";

  src = fetchFromGitHub {
    owner = "nadrad";
    repo = "h-m-m";
    rev = "ecf74433844e5542f78f64f8a79807818743adff";
    sha256 = "sha256-k35xld5VA/IloE0EMTP6MpKUfhdSOk8zEtmA8j1ZWs0=";
  };
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r h-m-m $out/bin/h-m-m
  '';
  postFixup = ''
    wrapProgram $out/bin/h-m-m \
      --set PATH ${lib.makeBinPath [
        php
        ncurses
        coreutils
        xclip
      ]}
  '';

  meta = with lib; {
    description = "A simple, fast, keyboard-centric terminal-based tool for working with mind maps";
    homepage = "https://github.com/nadrad/h-m-m";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tartavull ];
  };
}
