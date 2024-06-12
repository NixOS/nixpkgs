{ lib, buildEnv, git, fetchFromGitHub
, gitwebTheme ? false }:

let
  gitwebThemeSrc = fetchFromGitHub {
    owner = "kogakure";
    repo = "gitweb-theme";
    rev = "049b88e664a359f8ec25dc6f531b7e2aa60dd1a2";
    postFetch = ''
      mkdir -p "$TMPDIR/gitwebTheme"
      mv "$out"/* "$TMPDIR/gitwebTheme/"
      mkdir "$out/static"
      mv "$TMPDIR/gitwebTheme"/* "$out/static/"
    '';
    sha256 = "17hypq6jvhy6zhh26lp3nyi52npfd5wy5752k6sq0shk4na2acqi";
  };
in buildEnv {
  name = "gitweb-${lib.getVersion git}";

  ignoreCollisions = true;
  paths = lib.optional gitwebTheme gitwebThemeSrc
       ++ [ "${git}/share/gitweb" ];

  meta = git.meta // {
    maintainers = with lib.maintainers; [ ];
  };
}
