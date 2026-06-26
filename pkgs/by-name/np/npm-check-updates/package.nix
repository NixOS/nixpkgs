{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "22.2.7";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    tag = "v${version}";
    hash = "sha256-WwRCqmTqzbo+kG0u8+tiveDy0tpSrKUB6yFqpPZPg+A=";
  };

  npmDepsHash = "sha256-1rg/CtQdQ8K0nIrWJt/LxIBaLYcid1Oo76TLeMM+RJI=";

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
