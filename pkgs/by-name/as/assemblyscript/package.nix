{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.29";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = "assemblyscript";
    rev = "v${version}";
    hash = "sha256-Jhjq+kLRzDesTPHHonImCnuzt1Ay04n7+O9aK4knb5g=";
  };

  npmDepsHash = "sha256-mWRQPQVprM+9SCYd8M7NMDtiwDjSH5cr4Xlr5VP9eHo=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/assemblyscript";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
