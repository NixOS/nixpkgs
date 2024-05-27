{ lib, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, gawk
, git
, gnugrep
, ncurses
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.5.6";

  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "sha256-xd/ItpngreR77QTsSHLCgZfyvUZXBfOVPJaVtBZ2iTc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${builtins.placeholder "out"}"
  ];

  postInstall =
    let
      path = lib.makeBinPath [
        coreutils
        gawk
        git
        gnugrep
        ncurses
        util-linux
      ];
    in
    ''
      wrapProgram $out/bin/git-quick-stats --suffix PATH : ${path}
    '';

  meta = with lib; {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "A simple and efficient way to access various statistics in git repository";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.mit;
    mainProgram = "git-quick-stats";
  };
}
