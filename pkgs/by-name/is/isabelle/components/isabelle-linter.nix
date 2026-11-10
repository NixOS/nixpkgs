{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenvNoCC.mkDerivation rec {
  pname = "isabelle-linter";
  version = "2025-2-1.0.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2025-2-v1.0.0";
    hash = "sha256-V6Bnxyq/WI6U0sVBHA/vFOI0U3Vd5/GLCxbeWVitm8I=";
  };

  patches = [
    # Isabelle2025-2 wraps markup in command_range; without the patch then the
    # commands are ignored span and `isabelle lint` doesn't print anything
    ./isabelle-linter-command-range.patch
  ];

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
