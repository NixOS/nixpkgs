{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "16.14.12";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "v${version}";
    hash = "sha256-3/DaEgPF9+wofYqA1XrJul4/cNGuGeXAeRg0HW0O+Ok=";
  };

  npmDepsHash = "sha256-zUJKuiMycVCuXMh6caMzmi6qpgknVsvmqV3XykhlSBI=";

  meta = {
    changelog = "https://github.com/raineorshine/npm-check-updates/blob/${src.rev}/CHANGELOG.md";
    description = "Find newer versions of package dependencies than what your package.json allows";
    homepage = "https://github.com/raineorshine/npm-check-updates";
    license = lib.licenses.asl20;
    mainProgram = "ncu";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
