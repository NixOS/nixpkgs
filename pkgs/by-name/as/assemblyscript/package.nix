{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-8nY3Rst6i+RGW+kfjn/QSbYkaZf67k/KwuyIp40fCSM=";
  };

  npmDepsHash = "sha256-wj/PMoqUBjXqz8/KOFAH5P5eFty3pztpQ8inGIy+ve4=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
