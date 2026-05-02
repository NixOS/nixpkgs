{
  lib,
  stdenv,
  fetchFromGitHub,
  useMpi ? false,
  mpi,
}:

let
  mpi_or_pthreads = if useMpi then "MPI" else "PTHREADS";
  linux_or_darwin = if stdenv.hostPlatform.isDarwin then "mac" else "gcc";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "RAxML${lib.optionalString useMpi "-mpi"}";
  version = "8.2.13";

  src = fetchFromGitHub {
    owner = "stamatak";
    repo = "standard-RAxML";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-w+Eqi0GhVira1H6ZnMNeZGBMzDjiGT7JSFpQEVXONyk=";
  };

  buildInputs = lib.optionals useMpi [ mpi ];

  buildPhase = ''
    runHook preBuild

    make -f Makefile.SSE3.${mpi_or_pthreads}.${linux_or_darwin}
    make -f Makefile.AVX.${mpi_or_pthreads}.${linux_or_darwin}
    make -f Makefile.AVX2.${mpi_or_pthreads}.${linux_or_darwin}

    runHook postBuild
  '';

  # Fix build with gcc15 (-std=gnu23)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp raxmlHPC-${mpi_or_pthreads}-SSE3 $out/bin
    cp raxmlHPC-${mpi_or_pthreads}-AVX $out/bin
    cp raxmlHPC-${mpi_or_pthreads}-AVX2 $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Tool for Phylogenetic Analysis and Post-Analysis of Large Phylogenies";
    license = lib.licenses.gpl3;
    homepage = "https://sco.h-its.org/exelixis/web/software/raxml/";
    maintainers = with lib.maintainers; [
      unode
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
