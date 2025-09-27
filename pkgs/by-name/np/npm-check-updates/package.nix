{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "18.2.0";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "refs/tags/v${version}";
    hash = "sha256-llBQVABBjsb5JZEVAbj4lQzTrrwRisX1DNRlb6mnwuM=";
  };

  npmDepsHash = "sha256-USNLNMhBVN5LaTeCBdfzFrTgu8R2Z96PyjqICQH6Dqc=";

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
