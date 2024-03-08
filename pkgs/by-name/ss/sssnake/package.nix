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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zkErOV6Az0kJdwyXzMCnVW1997zpAB79TBvf/41Igic=";
  };
  buildInputs = [ncurses];
  makeFlags = [
    "PREFIX=$(out)"
  ];
  meta = with lib; {
    description = "Cli snake game that plays itself";
    homepage = "https://github.com/angeljumbo/sssnake";
    license = with licenses; [mit];
    platforms = platforms.unix;
    maintainers = with maintainers; [quantenzitrone];
  };
}
