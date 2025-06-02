{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-ZQBF4lHG+aCqwjqjH5Hrvxtz2OtpiCdyKvAbVoTuUkY=";
  };

  npmDepsHash = "sha256-LEPIQ47+Q15npjiiDHdnW/t4GE88rE7LjiJLuGtMmj4=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
