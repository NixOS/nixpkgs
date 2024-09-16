{
  lib,
  stdenv,
  fetchFromGitHub,
  blas,
  lapack,
  gfortran,
  fixDarwinDylibNames,
  nix-update-script,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "scs";
  version = "3.2.7";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    rev = "refs/tags/${version}";
    hash = "sha256-Y28LrYUuDaXPO8sce1pJIfG3A03rw7BumVgxCIKRn+U=";
  };

  # Actually link and add libgfortran to the rpath
  postPatch = ''
    substituteInPlace scs.mk \
      --replace "#-lgfortran" "-lgfortran" \
      --replace "gcc" "cc"
  '';

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [
    blas
    lapack
    gfortran.cc.lib
  ];

  doCheck = true;

  # Test demo requires passing data and seed; numbers chosen arbitrarily.
  postCheck = ''
    ./out/demo_socp_indirect 42 0.42 0.42 42
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r include $out/
    cp out/*.a out/*.so out/*.dylib $out/lib/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Splitting Conic Solver";
    longDescription = ''
      Numerical optimization package for solving large-scale convex cone problems
    '';
    homepage = "https://github.com/cvxgrp/scs";
    changelog = "https://github.com/cvxgrp/scs/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
