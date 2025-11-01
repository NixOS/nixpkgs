{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "19.1.2";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "refs/tags/v${version}";
    hash = "sha256-OksvcFO/PBEHZzji79E68AopPqpNZnOEBx5uN6ci4Nw=";
  };

  npmDepsHash = "sha256-JYUTLcEJFMt32gtQZ+9xS2npTCrW4EqBqM+SOAjAu+s=";

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
