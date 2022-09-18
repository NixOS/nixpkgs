{ stdenv
, lib
, makeWrapper
, php
, ncurses
, coreutils
, xclip
}:

stdenv.mkDerivation rec {
  name = "h-m-m";

  src = builtins.fetchGit {
    url = "https://github.com/nadrad/h-m-m.git";
    rev = "ecf74433844e5542f78f64f8a79807818743adff";
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
