{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.30";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-dmtKXU1bu25AzqxBhC9sWulMek5gRVnD0FN0G0XGQxU=";
  };

  npmDepsHash = "sha256-rj6tvevoDQQihTH+tYkrvhJRzynglG5roHHL7aZ6j+Y=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
