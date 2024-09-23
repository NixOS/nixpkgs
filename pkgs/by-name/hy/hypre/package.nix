{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "hypre";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-eFOyM3IzQUNm7cSnORA3NrKYotEBmLKC8mi+fcwPMQA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildInputs = [ mpi ];

  configureFlags = [
    "--enable-mpi"
    "--enable-shared"
  ];

  preBuild = ''
    makeFlagsArray+=(AR="ar -rcu")
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{include,lib}
    cp -r hypre/include/* $out/include
    cp -r hypre/lib/* $out/lib
    runHook postInstall
  '';

  meta = with lib; {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods.";
    homepage = "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ mkez ];
  };
})
