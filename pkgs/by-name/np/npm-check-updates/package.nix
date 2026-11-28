{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "23.1.1";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    tag = "v${version}";
    hash = "sha256-Q1ibfq+wCPScwWD/ttvz4WuBylY0WQMVbTZgCfh7hQg=";
  };

  npmDepsHash = "sha256-qyc66Onx9j1Psg9aUGMZA1mV+TzyfjxgQyYCGjWsdxc=";

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
