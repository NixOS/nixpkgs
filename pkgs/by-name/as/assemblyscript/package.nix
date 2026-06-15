{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.19";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-vnJ1cjUJ1LGBTYvTFPD4nhCR0GtT+63e/hDLe6Dypkk=";
  };

  npmDepsHash = "sha256-HoWkwqtusJS2mdIDFdHA3QR138UIKR2HO2e1/tqzhjI=";

  meta = {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}
