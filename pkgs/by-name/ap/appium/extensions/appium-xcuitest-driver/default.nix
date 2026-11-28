{
  fetchFromGitHub,
  buildNpmPackage,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-xcuitest-driver";
  packageName = pname;
  version = "11.14.1";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LAV44ZxtB8t2Nbzh+ks70t4gP6joudY/Tso6mdlAl5U=";
  };
  npmDepsHash = "sha256-5Q+VR7CnUOC1MOUQgACWw/ooen9oYIOyDrRX1pUxNAQ=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
