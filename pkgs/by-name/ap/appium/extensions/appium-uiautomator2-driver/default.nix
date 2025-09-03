{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-uiautomator2-driver";
  packageName = pname;
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S/Xbm7ooz97YLzXPv9whpANfjB0FRP+9UcPPTupg4Q4=";
  };
  npmDepsHash = "sha256-BYSfZLSwt0SdinhuGPURbR9xauTt5dYA8amW+gsaxS0=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
