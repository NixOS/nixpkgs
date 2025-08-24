{ buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "appium-xcuitest-driver";
  packageName = pname;
  version = "8.4.3";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w2Uk4SjikU+kkEZfRA5pE49shOImTQWMktcUQwC/Ym8=";
  };
  npmDepsHash = "sha256-bxM/HtKCJgmXA6dBhkiGT7r3TMfmVgO6JiqzMwH/ngs=";

  postPatch = ''
    # export APPIUM_SKIP_CHROMEDRIVER_INSTALL=true
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
