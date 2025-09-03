{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-xcuitest-driver";
  packageName = pname;
  version = "10.0.5";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uYicjH+UyKfBvq7iYmwIcaB25Xof17COylquLssEoa8=";
  };
  npmDepsHash = "sha256-z5V1jbvPI0mQ4UeGUpheoJraP5+EKr0rrWJXIrNS118=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
