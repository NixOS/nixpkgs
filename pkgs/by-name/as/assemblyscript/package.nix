{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.35";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-Wop7S7GvvXFcONER+TYIygLkAZpCdhMlPz3hhWSOZro=";
  };

  npmDepsHash = "sha256-DisQ5T5gEHkCZNBInN12uTquwrg3n/sOmNVz/iSI1Mw=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
