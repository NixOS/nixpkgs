{
  stdenv,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
  version = "2025-1.0.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2025-v1.0.0";
    hash = "sha256-cH9EoIbKa6cqLjw83gnYvCy+Dq0d5fFmJCabdPrRJeI=";
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

  meta = with lib; {
    description = "Linter component for Isabelle";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with maintainers; [ jvanbruegge ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
