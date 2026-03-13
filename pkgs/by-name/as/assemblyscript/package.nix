{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.10";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-eAIDHuLpKnQyJLyOGwdoWXFgE48kV0MJqdB5q6LuUXA=";
  };

  npmDepsHash = "sha256-IBO88U9dSoaC/JWgZDd7u8U+mSGd+BFCcUnrvCHo11k=";

  meta = {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}
