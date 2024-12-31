{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "hypre";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-h16+nZ6+GfddfBJDF6sphuZ9Sff++PxW2R58XgJsnsI=";
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
