{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  isabelle,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelle-linter";
  version = "2026-1.0.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2026-v1.0.0";
    hash = "sha256-9VDmFGtKSDN5nGlEmFMGPL7CvR4Dh9d15EDcHmNZSRY=";
  };

  nativeBuildInputs = [ isabelle ];

  buildPhase = ''
    export HOME=$TMP
    isabelle components -u $(pwd)
    isabelle scala_build
  '';

  installPhase = ''
    dir=$out/share/Isabelle${isabelle.version}/contrib/${finalAttrs.pname}-${finalAttrs.version}
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
})
