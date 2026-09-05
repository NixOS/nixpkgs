{
  fetchFromGitHub,
  buildNpmPackage,
  jq,
}:

buildNpmPackage rec {
  pname = "appium-uiautomator2-driver";
  packageName = pname;
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "appium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GB6qlDgKN2axoaaBLLhKZkItQHuJknktN7gjTuYj59U=";
  };
  npmDepsHash = "sha256-FQEdYwczBSeUpnsAsam9kwAHUHrE6UBBs+Hl8xQSDck=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${jq}/bin/jq 'del(.bin)' < package.json > package.json.patched && mv package.json.patched package.json
  '';

  dontNpmPrune = true;
}
