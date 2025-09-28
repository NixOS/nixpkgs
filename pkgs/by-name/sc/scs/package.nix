{
  lib,
  stdenv,
  fetchFromGitHub,
  blas,
  lapack,
  gfortran,
  fixDarwinDylibNames,
  nix-update-script,
  python3Packages,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "scs";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    tag = finalAttrs.version;
    hash = "sha256-BPVuihxLUuBbavKVhgdo1MdzkkDq2Nm/EYiAY/jwiqU=";
  };

  # Actually link and add libgfortran to the rpath
  postPatch = ''
    substituteInPlace scs.mk \
      --replace-fail "# -lgfortran" "-lgfortran" \
      --replace-fail "gcc" "cc"
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

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
    tests.scs-python = python3Packages.scs;
  };

  meta = {
    description = "Splitting Conic Solver";
    longDescription = ''
      Numerical optimization package for solving large-scale convex cone problems
    '';
    homepage = "https://github.com/cvxgrp/scs";
    changelog = "https://github.com/cvxgrp/scs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bhipple ];
  };
})
