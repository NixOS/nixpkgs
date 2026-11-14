{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "coffeescript";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "jashkenas";
    repo = "coffeescript";
    tag = version;
    hash = "sha256-zcNSUDbieY3dhbSyw5SZCxvBp0o0qPJ/ISzKnZvlNwA=";
  };

  npmDepsHash = "sha256-qOsCR+/amR80c+6QlUXK645dDQHHc2LKrYEeFC+Yc48=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  dontNpmBuild = true;

  meta = {
    description = "Little language that compiles into JavaScript";
    homepage = "https://github.com/jashkenas/coffeescript";
    license = lib.licenses.mit;
    mainProgram = "coffee";
    maintainers = with lib.maintainers; [ cdmistman ];
  };
}
