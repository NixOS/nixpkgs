{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.20";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-GacSQeJ7ddvQxsUU8qEEnpVvqDguud4HEZ4tpBJSuL0=";
  };

  npmDepsHash = "sha256-TpCcnQegA9/QeyEPB4pdl3dYn5DmGNB3sHP+GPiGLLE=";

  meta = {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}
