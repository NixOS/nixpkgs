{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "sssnake";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "angeljumbo";
    repo = "sssnake";
    rev = "v${version}";
    hash = "sha256-zkErOV6Az0kJdwyXzMCnVW1997zpAB79TBvf/41Igic=";
  };
  postPatch = ''
    substituteInPlace makefile --replace '-lncursesw' '-lncursesw -D_XOPEN_SOURCE=500'
  '';
  buildInputs = [ ncurses ];
  makeFlags = [
    "PREFIX=$(out)"
  ];
  meta = with lib; {
    description = "Cli snake game that plays itself";
    mainProgram = "sssnake";
    homepage = "https://github.com/angeljumbo/sssnake";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ quantenzitrone ];
  };
}
