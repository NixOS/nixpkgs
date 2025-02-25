{ buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "appium-xcuitest-driver";
  packageName = pname;
  version = "8.3.2";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W5zn9ovyoDo5vp606FNQ8LOlxGHaq/ZSnVSHfInLjU0=";
  };
  npmDepsHash = "sha256-KEdpDJ2xzerBlR8qfaMVxWbV7h2IniQCnNwVqzEKKdg=";

  postPatch = ''
    # export APPIUM_SKIP_CHROMEDRIVER_INSTALL=true
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
