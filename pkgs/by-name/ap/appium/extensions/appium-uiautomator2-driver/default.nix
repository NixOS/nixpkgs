{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-uiautomator2-driver";
  packageName = pname;
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DqnqMEnmWjWlDXa8oUp/k1XrVP6ZP/GOQ7mI4ab2iFo=";
  };
  npmDepsHash = "sha256-wqMZVGeSoqCoe+ju+Zz1P/Tz+jqkyuVT8/pc33JBoVM=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
