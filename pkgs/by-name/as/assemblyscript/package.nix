{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.17";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-EVaR3AsQ2X1KLE48XvIy/H0T+mdzZKaHnxF67Uwrxtk=";
  };

  npmDepsHash = "sha256-59phIZvV4AdZA0VuKYPmlLjZEtCM+1BuOJzIt1qEQeI=";

  meta = {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}
