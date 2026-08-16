{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sssnake";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "angeljumbo";
    repo = "sssnake";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RU+yYT+GcCsk0lBisE2/4Y9zMVLA6dbN4n0ibAovav4=";
  };
  postPatch = ''
    substituteInPlace makefile --replace '-lncursesw' '-lncursesw -D_XOPEN_SOURCE=500'
  '';
  buildInputs = [ ncurses ];
  makeFlags = [
    "PREFIX=$(out)"
  ];
  meta = {
    description = "Cli snake game that plays itself";
    mainProgram = "sssnake";
    homepage = "https://github.com/angeljumbo/sssnake";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
