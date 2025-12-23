{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-xcuitest-driver";
  packageName = pname;
  version = "10.8.3";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fclwYba68frnVP3J2VdbjREsZDZKSnmWMI/CT640VsQ=";
  };
  npmDepsHash = "sha256-6iGgvjj9Z0sD2Da60buvuhQJE5fRHi+KRV9sgaiewSk=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
