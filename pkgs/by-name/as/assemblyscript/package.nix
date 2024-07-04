{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.23";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pKb46AfL5MGKiH1AjyPeHw7ZeLnIiPYmf8b2bOkuRe0=";
  };

  npmDepsHash = "sha256-io/3T0LE1kupjtMg8rpQlRmIn048X0jqhKKj/W7Ilo0=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/${pname}";
    description = "TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
