{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenvNoCC.mkDerivation rec {
  pname = "isabelle-linter";
  version = "2025-1-1.0.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2025-1-v1.0.0";
    hash = "sha256-4J1lEvBNlfZudEEqsU3zOUewKSC4xZ3HTZGwgJCf9kc=";
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

  meta = {
    description = "Linter component for Isabelle";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with lib.maintainers; [ jvanbruegge ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
