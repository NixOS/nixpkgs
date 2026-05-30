{
  lib,
  buildEnv,
  git,
  fetchFromGitHub,
  gitwebTheme ? false,
}:

let
  gitwebThemeSrc = fetchFromGitHub {
    owner = "kogakure";
    repo = "gitweb-theme";
    rev = "d4cc1792f10dac16dbeee06d7e0902715e4fa51a";
    postFetch = ''
      mkdir -p "$TMPDIR/gitwebTheme"
      mv "$out"/* "$TMPDIR/gitwebTheme/"
      mkdir "$out/static"
      mv "$TMPDIR/gitwebTheme"/* "$out/static/"
    '';
    hash = "sha256-+e8ZP8hVGWQsXgyWUd/rF9+GRHNHJLFpOr5nsNIieyo";
  };
in
buildEnv {
  inherit (git) version;
  pname = "gitweb";

  ignoreCollisions = true;
  paths = lib.optional gitwebTheme gitwebThemeSrc ++ [ "${git}/share/gitweb" ];

  meta = git.meta // {
    maintainers = [ ];
  };
}
