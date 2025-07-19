{ buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "appium-uiautomator2-driver";
  packageName = pname;
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-r9pDyyYotm2hbND40MumSJ8hBUYqwPCkge5EHl0y02E=";
  };
  npmDepsHash = "sha256-GhnWIqu3XYaP1QXUqXPvZ8AO6r4ZRXR1KIUmnc8ZBTc=";

  postPatch = ''
    # export APPIUM_SKIP_CHROMEDRIVER_INSTALL=true
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
