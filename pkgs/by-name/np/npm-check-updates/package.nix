{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "17.1.14";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "refs/tags/v${version}";
    hash = "sha256-PIaT5Wg+jEd4NPlLVQKnJ429489ZSQPagCc/+h2EFrI=";
  };

  npmDepsHash = "sha256-k/TBMdOyTjVBir5wIujMPHa+2FRvzORX7dXpLrMhTqY=";

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
