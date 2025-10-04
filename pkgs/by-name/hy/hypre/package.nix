{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypre";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zu9YWfBT2WJxPg6JHrXjZWRM9Ai1p28EpvAx6xfdPsY=";
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
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    homepage = "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ mkez ];
  };
})
