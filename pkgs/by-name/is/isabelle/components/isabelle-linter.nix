{
  stdenv,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
  version = "2024-1.0.1";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2024-v1.0.1";
    hash = "sha256-oTrwcfJgbkpkIweDIyc6lZjAvdS9J4agPoJgZzH+PuQ=";
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
