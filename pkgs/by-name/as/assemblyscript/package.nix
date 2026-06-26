{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.13";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-AN9W6IYmMFFiD1Au3uW+7jr2xOwVcOGd5e61cqVNnbs=";
  };

  npmDepsHash = "sha256-5s420YWTc4bZ5oZRBjinw4lAfMTPrnrIWx4IM3Ysuqo=";

  meta = {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}
