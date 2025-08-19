{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypre";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OrpClN9xd+8DdELVnI4xBg3Ih/BaoBiO0w/QrFjUclw=";
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
