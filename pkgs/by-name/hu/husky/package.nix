{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "husky";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "typicode";
    repo = "husky";
    rev = "v${version}";
    hash = "sha256-KoF2+vikgFyCGjfKeaqkC720UVMuvCIn9ApDPKbudsA=";
  };

  npmDepsHash = "sha256-u1dndTKvInobva+71yI2vPiwrW9vqzAJ2sDAqT9YJsg=";

  meta = {
    description = "Git hooks made easy";
    mainProgram = "husky";
    homepage = "https://github.com/typicode/husky";
    changelog = "https://github.com/typicode/husky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
