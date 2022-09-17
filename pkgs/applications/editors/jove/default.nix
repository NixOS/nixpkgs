{ lib, stdenv, fetchFromGitHub
, groff
, ncurses
, makeWrapper
} :

stdenv.mkDerivation rec {
  pname = "jove";
  version = "4.17.4.6";

  src = fetchFromGitHub {
    owner = "jonmacs";
    repo = "jove";
    rev = version;
    sha256 = "sha256-UCjqF0i43TSvtG5uxb2SA/F9oGBeo/WdEVJlrSSHV8g=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    groff
    ncurses
  ];

  dontConfigure = true;

  preBuild = ''
    makeFlagsArray+=(SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" \
      TERMCAPLIB=-lncurses JOVEHOME=${placeholder "out"})
  '';

  postInstall = ''
    wrapProgram $out/bin/teachjove \
      --prefix PATH ":" "$out/bin"
  '';

  meta = with lib; {
    description = "Jonathan's Own Version of Emacs";
    homepage = "https://github.com/jonmacs/jove";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/jove.x86_64-darwin
  };
}
