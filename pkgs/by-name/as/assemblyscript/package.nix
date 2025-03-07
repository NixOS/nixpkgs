{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.34";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-GM45I8L+cgdbky8wAhpKnWVqCPYIBOH3HyV131tSHkQ=";
  };

  npmDepsHash = "sha256-ptndMTc68/L+YgrfwhK/woVzyzG8KpL9KPGGtRXFdho=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
