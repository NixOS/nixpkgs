{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenvNoCC.mkDerivation rec {
  pname = "isabelle-linter";
  version = "2025-2-v1.1.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle${version}";
    hash = "sha256-OfaISXdjLzg11fcOvikPEDlyWInp0xVwKtJSOiNXyZ0=";
  };

  nativeBuildInputs = [ isabelle ];

  buildPhase = ''
    export HOME=$TMP
    isabelle components -u $(pwd)
    isabelle scala_build
  '';

  installPhase = ''
    dir=$out/Isabelle${isabelle.version}/contrib/${pname}-${version}
    mkdir -p $dir
    cp -r * $dir/
  '';

  passthru.tests = {
    inherit (isabelle.tests) linter;
  };

  meta = {
    description = "Linter component for Isabelle";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with lib.maintainers; [ jvanbruegge ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
