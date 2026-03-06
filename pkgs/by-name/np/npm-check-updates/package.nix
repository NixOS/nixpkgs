{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "19.6.3";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    tag = "v${version}";
    hash = "sha256-cZqfUlg+B8MeBky8RdiDWJDBATYuXe3bc5Qwg2y9UQs=";
  };

  npmDepsHash = "sha256-WTIeElZGEjuDGNpI30h9kClv7wdWHur5H0Qvq9PW+wc=";

  postPatch = ''
    sed -i '/"prepare"/d' package.json
  '';

  makeCacheWritable = true;

  meta = {
    changelog = "https://github.com/raineorshine/npm-check-updates/blob/${src.rev}/CHANGELOG.md";
    description = "Find newer versions of package dependencies than what your package.json allows";
    homepage = "https://github.com/raineorshine/npm-check-updates";
    license = lib.licenses.asl20;
    mainProgram = "ncu";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
